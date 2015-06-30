﻿using System;
using System.Collections;
using System.IO;
using System.Web.Mvc;
using Commons.Collections;
using NVelocity;
using NVelocity.App;
using NVelocity.Runtime;

namespace NVelocityEngine
{
    public class NVelocityViewEngine : VirtualPathProviderViewEngine, IViewEngine
    {
        public static NVelocityViewEngine Default = null;

        private static readonly IDictionary DEFAULT_PROPERTIES = new Hashtable();
        private readonly VelocityEngine _engine;

        static NVelocityViewEngine()
        {
            string targetViewFolder = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "views");
            //DEFAULT_PROPERTIES.Add(RuntimeConstants.RESOURCE_LOADER, "file");
            DEFAULT_PROPERTIES.Add(RuntimeConstants.FILE_RESOURCE_LOADER_PATH, targetViewFolder);
            DEFAULT_PROPERTIES.Add("file.resource.loader.class", "NVelocityEngine.FileResourceLoaderEx\\,NVelocityEngine");


            Default = new NVelocityViewEngine();
        }

        public NVelocityViewEngine()
            : this(DEFAULT_PROPERTIES)
        {
        }

        public NVelocityViewEngine(IDictionary properties)
        {
            base.MasterLocationFormats = new string[] { "~/Views/{1}/{0}.vm", "~/Views/Shared/{0}.vm" };
            base.AreaMasterLocationFormats = new string[] { "~/Areas/{2}/Views/{1}/{0}.vm", "~/Areas/{2}/Views/Shared/{0}.vm" };
            base.ViewLocationFormats = new string[] { "~/Views/{1}/{0}.vm", "~/Views/Shared/{0}.vm" };
            base.AreaViewLocationFormats = new string[] { "~/Areas/{2}/Views/{1}/{0}.vm", "~/Areas/{2}/Views/Shared/{0}.vm" };
            base.PartialViewLocationFormats = base.ViewLocationFormats;
            base.AreaPartialViewLocationFormats = base.AreaViewLocationFormats;
            base.FileExtensions = new string[] { "vm" };


            if (properties == null) properties = DEFAULT_PROPERTIES;

            ExtendedProperties props = new ExtendedProperties();
            foreach (string key in properties.Keys)
            {
                props.AddProperty(key, properties[key]);
            }

            _engine = new VelocityEngine();
            _engine.Init(props);
        }

        protected override IView CreateView(ControllerContext controllerContext, string viewPath, string masterPath)
        {
            Template viewTemplate = GetTemplate(viewPath);
            Template masterTemplate = GetTemplate(masterPath);
            NVelocityView view = new NVelocityView(controllerContext, viewTemplate, masterTemplate);
            return view;
        }
        protected override IView CreatePartialView(ControllerContext controllerContext, string partialPath)
        {
            Template viewTemplate = GetTemplate(partialPath);
            NVelocityView view = new NVelocityView(controllerContext, viewTemplate, null);
            return view;
        }
        public Template GetTemplate(string viewPath)
        {
            if (string.IsNullOrEmpty(viewPath))
            {
                return null;
            }
            return _engine.GetTemplate(System.Web.Hosting.HostingEnvironment.MapPath(viewPath));
        }

    }
}
