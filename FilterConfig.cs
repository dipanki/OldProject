using System.Web;
using System.Web.Mvc;

namespace siewli
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            //filters.Add(new HandleErrorAttribute());
            filters.Add(new Controllers.ErrorController());
        }
    }
}