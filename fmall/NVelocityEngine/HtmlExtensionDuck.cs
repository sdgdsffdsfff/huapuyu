﻿using System;
using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace NVelocityEngine
{
    public class HtmlExtensionDuck : ExtensionDuck
    {
        public static readonly Type[] HTML_EXTENSION_TYPES =
            new Type[]
				{
					typeof(DisplayExtensions),
                    typeof(DisplayTextExtensions),
                    typeof(EditorExtensions),
					typeof(FormExtensions), 
                    typeof(InputExtensions), 
                    typeof(LabelExtensions),
                    typeof(LinkExtensions), 
                    typeof(MvcForm),
					typeof(PartialExtensions),
                    typeof(RenderPartialExtensions),
                    typeof(SelectExtensions),
                    typeof(TextAreaExtensions),
                    typeof(ValidationExtensions)
				};

        public HtmlExtensionDuck(ViewContext viewContext, IViewDataContainer container)
            : this(new HtmlHelper(viewContext, container))
        {
        }

        public HtmlExtensionDuck(HtmlHelper htmlHelper)
            : this(htmlHelper, HTML_EXTENSION_TYPES)
        {
        }

        public HtmlExtensionDuck(HtmlHelper htmlHelper, params Type[] extentionTypes)
            : base(htmlHelper, extentionTypes)
        {
        }
    }
}
