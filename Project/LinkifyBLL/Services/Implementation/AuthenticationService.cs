using LinkifyBLL.Services.Abstraction;
using LinkifyDAL.Entities;
using LinkifyDAL.Repo.Abstraction;
using Microsoft.AspNetCore.Identity;

namespace LinkifyBLL.Services.Implementation
{
    public class AuthenticationService : IAuthenticationService
    {
        private readonly IUserRepository _userRepo;
        private readonly SignInManager<User> _signInManager;

        public AuthenticationService(
            IUserRepository userRepo,
            SignInManager<User> signInManager)
        {
            _userRepo = userRepo;
            _signInManager = signInManager;
        }

        public async Task<User> LoginAsync(string email, string password, bool rememberMe)
        {
            var user = await _userRepo.FindByEmailAsync(email);
            if (user == null) return null;

            if (!await _userRepo.CheckPasswordAsync(user, password))
                return null;

            await _signInManager.PasswordSignInAsync(user, password, rememberMe, false);
            return user;
        }

        public async Task LogoutAsync()
        {
            await _signInManager.SignOutAsync();
        }

        public async Task<bool> IsEmailConfirmedAsync(string email)
        {
            var user = await _userRepo.FindByEmailAsync(email);
            return user?.EmailConfirmed ?? false;
        }
    }
}
