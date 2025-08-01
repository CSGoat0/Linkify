using LinkifyBLL.ModelView;
using LinkifyBLL.Services.Abstraction;
using LinkifyDAL.Entities;
using Microsoft.AspNetCore.Mvc;

namespace LinkifyPLL.Controllers
{
    public class UserController : Controller
    {
        public readonly IUserService IUS;
        public UserController(IUserService ius) { 
            this.IUS = ius;
        }
        public IActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public IActionResult Register() { 
            return View();
        }
        [HttpPost]
        public IActionResult Register(UserRegisterMV model)
        {

            if (ModelState.IsValid)
            {
                IUS.RegisterUserAsync(model, model.Password);
                return RedirectToAction("Index", controllerName: "Home");
            }
            else
            {
                return View(model);
            }
        }
    }
}
