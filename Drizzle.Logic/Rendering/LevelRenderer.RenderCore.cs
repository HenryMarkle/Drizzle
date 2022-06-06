using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using Drizzle.Lingo.Runtime;
using Drizzle.Ported;
using Serilog;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats.Png;

namespace Drizzle.Logic.Rendering;

public sealed partial class LevelRenderer
{
    private static readonly string PngSoftwareName = $"Drizzle {Assembly.GetExecutingAssembly().GetName().Version}";

    // This partial contains core rendering logic.
    private int _cameraIndex;
    private int _countCamerasDone;

    public void DoRender()
    {
        RenderStart();

        // Set up camera order.
        List<int> camOrder;
        if (_renderVoxels)
        {
            camOrder = new List<int> { 0 };
        }
        else if (_singleCamera is { } s)
        {
            camOrder = new List<int> { s + 1 };
        }
        else
        {
            camOrder = Enumerable.Range(1, (int)Movie.gCameraProps.cameras.count).ToList();

            if (Movie.gPrioCam is not (null or 0))
            {
                camOrder.Remove(Movie.gPrioCam);
                camOrder.Insert(0, Movie.gPrioCam);
            }
        }

        foreach (var camIndex in camOrder)
        {
            try
            {
                RenderSetupCamera(camIndex);

                RenderLayers();
                RenderPropsPreEffects();
                RenderEffects();
                RenderPropsPostEffects();
                if (_renderVoxels)
                {
                    RenderStartFrame(RenderStage.SaveFile);
                    SaveVoxels();
                }
                else
                {
                    RenderLight();
                    RenderFinalize();
                    RenderColors();
                    RenderFinished();

                    RenderStartFrame(RenderStage.SaveFile);
                    // Save image.
                    var fileName = Path.Combine(
                        LingoRuntime.MovieBasePath,
                        "Levels",
                        $"{Movie.gLoadedName}_{camIndex}.png");

                    var file = File.OpenWrite(fileName);
                    var image = _runtime.GetCastMember("finalImage")!.image!;
                    OnScreenRenderCompleted?.Invoke(camIndex, image);

                    // Save the image
                    var imgSharp = image.GetImgSharpImage();
                    imgSharp.Metadata.GetPngMetadata().TextData.Add(
                        new PngTextData("Software", PngSoftwareName, null, null));
                    imgSharp.SaveAsPng(file);
                }

                _countCamerasDone += 1;
            }
            catch (RenderCancelledException)
            {
                // Pass through.
                throw;
            }
            catch (Exception e)
            {
                throw new RenderCameraException($"Exception on camera {camIndex}", e);
            }
        }

        // Output level data.
        Movie.newmakelevel(Movie.gLoadedName);
    }

    private void RenderStart()
    {
        RenderStartFrame(RenderStage.Start);
        _runtime.CreateScript<renderStart>().exitframe();
    }

    private void RenderSetupCamera(int camIndex)
    {
        RenderStartFrame(RenderStage.CameraSetup);

        _cameraIndex = camIndex;
        Movie.gCurrentRenderCamera = new LingoNumber(camIndex);

        // Camera 0 covers the entire level.
        if (camIndex == 0)
        {
            Movie.gRenderCameraTilePos = new LingoPoint(0, 0);
            Movie.gRenderCameraPixelPos = new LingoPoint(0, 0);
            Movie.gRenderCameraTileSize = Movie.gLOprops.size;
        }
        else
        {
            LingoPoint camera = (LingoPoint)Movie.gCameraProps.cameras[camIndex];

            Movie.gRenderCameraTilePos =
                new LingoPoint(
                    (camera.loch / (LingoNumber)20.0 - (LingoNumber)0.49999).integer,
                    (camera.locv / (LingoNumber)20.0 - (LingoNumber)0.49999).integer);

            Movie.gRenderCameraPixelPos = camera - (Movie.gRenderCameraTilePos * 20);
            Movie.gRenderCameraPixelPos.loch = Movie.gRenderCameraPixelPos.loch.integer;
            Movie.gRenderCameraPixelPos.locv = Movie.gRenderCameraPixelPos.locv.integer;
            Movie.gRenderCameraTileSize = new LingoPoint(100.0, 60.0);

            Movie.gRenderCameraTilePos += new LingoPoint(-15, -10);
        }
    }

    private void RenderLayers()
    {
        int cols;
        int rows;

        if((LingoNumber)Movie.gCurrentRenderCamera == 0)
        {
            cols = (int)Movie.gLOprops.size.loch;
            rows = (int)Movie.gLOprops.size.locv;
        }
        else
        {
            cols = 100;
            rows = 60;
        }

        RenderStartFrame(RenderStage.RenderLayers);

        for (var i = 0; i < 30; i++)
        {
            _runtime.GetCastMember($"layer{i}")!.image = new LingoImage(cols * 20, rows * 20, 32);
            _runtime.GetCastMember($"gradientA{i}")!.image = new LingoImage(cols * 20, rows * 20, 32);
            _runtime.GetCastMember($"gradientB{i}")!.image = new LingoImage(cols * 20, rows * 20, 32);
            _runtime.GetCastMember($"layer{i}dc")!.image = new LingoImage(cols * 20, rows * 20, 32);
        }

        _runtime.GetCastMember("rainBowMask")!.image = new LingoImage(cols * 20, rows * 20, 32);

        var sw = Stopwatch.StartNew();
        Movie.gSkyColor = new LingoColor(0, 0, 0);
        Movie.gTinySignsDrawn = new LingoNumber(0);
        Movie.gRenderTrashProps = new LingoList();
        _runtime.GetCastMember(@"finalImage")!.image = new LingoImage(cols * 20, rows * 20, 32);
        _runtime.Global.the_randomSeed = Movie.gLOprops.tileseed;

        for (var i = 3; i > 0; i--)
        {
            // Don't measure pauses as part of the stopwatch.
            sw.Stop();
            RenderStartFrame(new RenderStageStatusLayers(i));
            sw.Start();

            Movie.setuplayer(new LingoNumber(i));
        }

        Movie.gLastImported = "";
        Log.Information("{LevelName} rendered layers in {ElapsedMilliseconds} ms",
            Movie.gLoadedName, sw.ElapsedMilliseconds);

        Movie.c = new LingoNumber(1);
    }

    private void RenderPropsPreEffects()
    {
        RenderStartFrame(RenderStage.RenderPropsPreEffects);
        Movie.afterEffects = new LingoNumber(0);
        _runtime.CreateScript<renderPropsStart>().exitframe();

        var script = _runtime.CreateScript<renderProps>();
        while (Movie.keepLooping == 1)
        {
            RenderStartFrame(RenderStage.RenderPropsPreEffects);
            script.newframe();
        }
    }

    private void RenderEffects()
    {
        RenderStartFrame(RenderStage.RenderEffects);
        _runtime.CreateScript<renderEffectsStart>().exitframe();

        var script = _runtime.CreateScript<renderEffects>();
        while (Movie.keepLooping == 1)
        {
            var effectsList = (LingoList)Movie.gEEprops.effects;
            var effectNames = effectsList.List.Select(e => (string)((dynamic)e!).nm).ToArray();
            var totalCount = effectsList.List.Count;
            var curr = (int)Movie.r;
            var vert = (int)Movie.vertRepeater;
            RenderStartFrame(new RenderStageStatusEffects(totalCount, curr, vert, effectNames));
            script.newframe();
        }
    }

    private void RenderPropsPostEffects()
    {
        RenderStartFrame(RenderStage.RenderPropsPostEffects);
        Movie.afterEffects = new LingoNumber(1);
        _runtime.CreateScript<renderPropsStart>().exitframe();

        var script = _runtime.CreateScript<renderProps>();
        while (Movie.keepLooping == 1)
        {
            RenderStartFrame(RenderStage.RenderPropsPostEffects);
            script.newframe();
        }
    }

    private void RenderLight()
    {
        RenderStartFrame(RenderStage.RenderLight);
        _runtime.CreateScript<renderLightStart>().exitframe();

        if (Movie.gLOprops.light == new LingoNumber(0))
            return;

        var script = _runtime.CreateScript<renderLight>();
        while (Movie.keepLooping == 1)
        {
            var curr = (int)Movie.c;
            RenderStartFrame(new RenderStageStatusLight(curr));
            script.newframe();
        }
    }

    private void RenderFinalize()
    {
        RenderStartFrame(RenderStage.Finalize);
        _runtime.CreateScript<finalize>().exitframe();
    }

    private void RenderColors()
    {
        var oldRenderColors = Environment.GetEnvironmentVariable("DRIZZLE_OLD_RENDER_COLORS") is not (null or "0");

        if (!oldRenderColors)
        {
            Log.Debug("Using new RenderColors");
            while (Movie.keepLooping == 1)
            {
                RenderStartFrame(RenderStage.RenderColors);
                RenderColorsNewFrame();
            }
        }
        else
        {
            Log.Debug("Using old RenderColors");
            var script = _runtime.CreateScript<renderColors>();
            while (Movie.keepLooping == 1)
            {
                RenderStartFrame(RenderStage.RenderColors);
                script.newframe();
            }
        }
    }

    private void RenderFinished()
    {
        RenderStartFrame(RenderStage.Finished);
        _runtime.CreateScript<finished>().exitframe();
    }
}
