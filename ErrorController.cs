using siewli.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace siewli.Controllers
{
    public class ErrorController : HandleErrorAttribute
    {
        //
        // GET: /Error/
        /// <summary>
        /// OnException used for error display
        /// </summary>
        /// <param name="filterContext"></param>
        public override void OnException(ExceptionContext filterContext)
        {
            Exception e = filterContext.Exception;
            //Log Exception e
            string ip = filterContext.HttpContext.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(ip))
            {
                ip = filterContext.HttpContext.Request.ServerVariables["REMOTE_ADDR"];
            }

            logerror(filterContext.Controller.ToString(), filterContext.RouteData.Values["action"].ToString(),filterContext.Exception.ToString() + filterContext.Exception.Message.ToString(), filterContext.HttpContext.Request.Browser.Browser.ToString(), filterContext.HttpContext.Request.Url.AbsoluteUri.ToString(), ip);
            
            sendmail(System.Configuration.ConfigurationManager.AppSettings["Admin_Log_email"], null, "Error", "Controller :- " + filterContext.Controller.ToString() + "<br/> Action :- " + filterContext.RouteData.Values["action"].ToString() + "<br/> Error Message  :- " + filterContext.Exception.Message.ToString() + "<br/> <br/> Error From Browser :-  " + filterContext.HttpContext.Request.Browser.Browser.ToString() + "<br/> <br/> Url  :- " + filterContext.HttpContext.Request.Url.AbsoluteUri.ToString() + "<br/> <br/> ip  :- " + ip);
            //filterContext.Result = new ViewResult
            //{

            //    ViewName = "~/Views/Home/Error.cshtml"
            //};
            filterContext.ExceptionHandled = true;

            filterContext.HttpContext.Response.Write("<script type='text/javascript'>");
            filterContext.HttpContext.Response.Write("window.location = '/Home/Error'</script>");
            filterContext.HttpContext.Response.Flush();
        }
        /// <summary>
        /// send error email to admin
        /// </summary>
        /// <param name="emailid">emailid is a email address</param>
        /// <param name="otheremail"></param>
        /// <param name="subject">subject </param>
        /// <param name="body">body is a error description</param>
        public void sendmail(string emailid, List<string> otheremail, string subject, string body)
        {
            try
            {

                SiewliEntities _db = new SiewliEntities();
                tbl_Settings objSetting = _db.tbl_Settings.FirstOrDefault();
                string Smtphost = objSetting.Host.Trim();
                string SmtpUsrname = objSetting.SmtpUsername.Trim();
                string SmtpPwd = objSetting.SmtpPassword.Trim();
                string Smtpport = objSetting.Port.ToString().Trim();
                string Smtpsendername = objSetting.SmtpUsername.Trim();
                System.Net.Mail.MailMessage mm = new System.Net.Mail.MailMessage(new System.Net.Mail.MailAddress(Smtpsendername, "Master Siewli"), new System.Net.Mail.MailAddress(emailid));

                //   mm.IsBodyHtml = true; // This line
                mm.Subject = subject;
                mm.Body = body;
                mm.IsBodyHtml = true;
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
                smtp.Host = Smtphost;
                smtp.EnableSsl = false;
                if (otheremail != null)
                {
                    if (otheremail.Count > 0)
                    {
                        foreach (string s in otheremail)
                        {
                            mm.To.Add(s);
                        }
                    }
                }
                System.Net.NetworkCredential NetworkCred = new System.Net.NetworkCredential();
                NetworkCred.UserName = SmtpUsrname;
                NetworkCred.Password = SmtpPwd;
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = Convert.ToInt32(Smtpport);
                smtp.Send(mm);
            }
            catch (Exception ex)
            {

            }
        }

        /// <summary>
        /// logerror used for create log files of error
        /// </summary>
        /// <param name="cntlr">This parameter is used for get cntlr</param>
        /// <param name="acton">This parameter is used for get acton</param>
        /// <param name="msg">This parameter is used for get msg</param>
        /// <param name="browser">This parameter is used for get browser</param>
        /// <param name="path">This parameter is used for get path</param>
        /// <param name="ip">This parameter is used for get ip</param>
        static void logerror(string cntlr, string acton, string msg, string browser, string path, string ip)
        {
            string fileName = DateTime.Now.ToString("MM_dd_yyyy") + ".txt";
            try
            {

                System.IO.File.AppendAllLines(HttpContext.Current.Server.MapPath("~/Errorlogs/" + fileName), new string[] { "Action Name:" + acton, "Controller Name:" + cntlr, "Error Time:" + DateTime.Now, "Url:" + path, "Customer Ip:" + ip, "Error :" + msg + "----------------------" });
                
            }
            catch (IOException)
            {
                // the file is locked
            }
        }

    }
}
