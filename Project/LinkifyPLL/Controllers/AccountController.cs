using LinkifyBLL.ModelView;
using LinkifyBLL.Services.Abstraction;
using Microsoft.AspNetCore.Mvc;

namespace LinkifyPLL.Controllers
{
    public class AccountController : Controller
    {
        private readonly IAuthenticationService _authService;
        public AccountController(IAuthenticationService authService)
        {
            _authService = authService;
        }
        public IActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public IActionResult Login() { 
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> Login(UserLoginMV model)
        {
            var user = await _authService.LoginAsync(model.Email, model.Password, true);
            if (user == null)
            {
                ModelState.AddModelError("", "Invalid credentials");
                return View(model);
            }
            return RedirectToAction("Index", "Home");
        }
    }
}
