using LinkifyDAL.Entities;
using LinkifyDAL.Repo.Abstraction;
using Microsoft.AspNetCore.Identity;

namespace LinkifyDAL.Repo.Implementation
{
    public class UserRepository : IUserRepository
    {
        private readonly UserManager<User> _userManager;

        public UserRepository(UserManager<User> userManager)
        {
            _userManager = userManager;
        }

        public async Task<bool> ChangeUserPasswordAsync(User user, string oldPassword, string newPassword)
        {
            var result = await _userManager.ChangePasswordAsync(user, oldPassword, newPassword);
            return result.Succeeded;
        }

        //public async Task<bool> EditUserAsync(User oldUser, User newUser)
        //{
        //    if (oldUser == null || newUser == null)
        //        return false;
        //    try
        //    {
        //        oldUser.Edit(newUser.UserName, newUser.ImgPath, newUser.Status);
        //        var result = await _userManager.UpdateAsync(oldUser);
        //        return result.Succeeded;
        //    }
        //    catch
        //    {
        //        return false;
        //    }
        //}

        public async Task<bool> RegisterUserAsync(User user, string password)
        {
            var result = await _userManager.CreateAsync(user, password);
            return result.Succeeded;
        }

        public async Task<bool> DeleteUserAsync(User user)
        {
            if (user == null)
                return false;
            try
            {
                user.Delete();
                var result = await _userManager.UpdateAsync(user);
                return result.Succeeded;
            }
            catch
            {
                return false;
            }
        }
        public async Task<User> FindByEmailAsync(string email)
        {
            return await _userManager.FindByEmailAsync(email);
        }

        public async Task<bool> CheckPasswordAsync(User user, string password)
        {
            return await _userManager.CheckPasswordAsync(user, password);
        }

        public async Task<IdentityResult> CreateUserAsync(User user, string password)
        {
            return await _userManager.CreateAsync(user, password);
        }

        public async Task<IdentityResult> UpdateUserAsync(User user)
        {
            return await _userManager.UpdateAsync(user);
        }
    }
}
