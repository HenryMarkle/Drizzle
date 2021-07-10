﻿using System;

namespace Drizzle.Lingo.Runtime
{
    public sealed partial class LingoGlobal
    {
        public Movie _movie { get; private set; }

        public void go(dynamic a) => _movie.go(a);
        public int the_frame => _movie.frame;

        public sealed class Movie
        {
            private readonly LingoGlobal _global;

            public Window window { get; }

            public Movie(LingoGlobal global)
            {
                _global = global;
                window = new Window(global);
            }

            public int frame { get; set; }

            public string path => throw new NotImplementedException();

            public dynamic stage => throw new NotImplementedException();

            public void go(dynamic a)
            {

            }
        }

        public sealed class Window
        {
            public Window(LingoGlobal lingoGlobal)
            {

            }

            public dynamic appearanceoptions => throw new NotImplementedException();
            public int resizable { get; set; }
            public LingoRect rect { get; set; }
        }
    }
}