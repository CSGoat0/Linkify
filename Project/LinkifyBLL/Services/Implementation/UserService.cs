using LinkifyBLL.ModelView;
using LinkifyBLL.Services.Abstraction;
using LinkifyDAL.Entities;
using LinkifyDAL.Repo.Abstraction;

namespace LinkifyBLL.Services.Implementation
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepo;

        public UserService(IUserRepository userRepo)
        {
            _userRepo = userRepo;
        }

        public async Task<bool> RegisterUserAsync(UserRegisterMV userMV, string password)
        {
            User user = new User(userMV.Name, userMV.Email, null, null);
            return await _userRepo.RegisterUserAsync(user, password);
        }

        public async Task<bool> DeleteUserAsync(UserMV userMV)
        {
            var user = await _userRepo.FindByEmailAsync(userMV.Email);
            if (user == null) return false;

            return await _userRepo.DeleteUserAsync(user);
        }

        public async Task<bool> UpdateUserAsync(UserMV oldUserMV, UserMV newUserMV)
        {
            var existingUser = await _userRepo.FindByEmailAsync(oldUserMV.Email);
            if (existingUser == null) return false;

            existingUser.Edit(newUserMV.Name, newUserMV.ImgPath, newUserMV.Status);
            var result = await _userRepo.UpdateUserAsync(existingUser);
            return result.Succeeded;
        }

        public async Task<bool> ChangeUserPasswordAsync(UserMV userMV, string oldPassword, string newPassword)
        {
            var user = await _userRepo.FindByEmailAsync(userMV.Email);
            if (user == null) return false;

            return await _userRepo.ChangeUserPasswordAsync(user, oldPassword, newPassword);
        }
    }
}


//public async Task<bool> ChangeUserPasswordAsync(UserMV user, string oldPassword, string newPassword)
//{
//    User US = new User(user.Id, user.Name, user.ImgPath, user.Status);
//    try
//    {
//        if (newPassword != null)
//        {
//            var result = await IUR.ChangeUserPassword(US, oldPassword, newPassword);
//            return result;
//        }
//        else return false;
//    }
//    catch
//    {
//        return false;
//    }
//}
//public async Task<bool> DeleteUserAsync(UserMV user)
//{
//    User US = new User(user.Id, user.Name, user.ImgPath, user.Status);
//    try
//    {
//        var result = await IUR.DeleteUserAsync(US);
//        return result;
//    }
//    catch
//    {
//        return false;
//    }
//}
//public async Task<bool> UpdateUserAsync(UserMV oldUser, UserMV newUser)
//{
//    User US1 = new User(oldUser.Id, oldUser.Name, oldUser.ImgPath, oldUser.Status);
//    User US2 = new User(newUser.Id, newUser.Name, newUser.ImgPath, newUser.Status);
//    try
//    {
//        var result = await IUR.UpdateUserAsync(US1, US2);
//        return result;
//    }
//    catch { return false; }
//}
//public async Task<bool> RegisterUserAsync(UserMV user, string password)
//{
//    User US = new User(user.Id, user.Name, user.ImgPath, user.Status);
//    try
//    {
//        var result = await IUR.RegisterUserAsync(US, password);
//        return result;
//    }
//    catch { 
//        return false ;
//    }
//}

//public async Task<User> LoginAsync(string email, string password, bool rememberMe)
//{
//    var user = await _authRepo.FindByEmailAsync(email);
//    if (user == null) return null;

//    var isValidPassword = await _authRepo.CheckPasswordAsync(user, password);
//    if (!isValidPassword) return null;

//    await _signInManager.PasswordSignInAsync(
//        user, password, rememberMe, lockoutOnFailure: false);

//    return user;
//}

//public async Task LogoutAsync()
//{
//    await _signInManager.SignOutAsync();
//}

//public async Task<bool> RegisterAsync(User user, string password)
//{
//    var result = await _authRepo.CreateUserAsync(user, password);
//    return result.Succeeded;
//}
