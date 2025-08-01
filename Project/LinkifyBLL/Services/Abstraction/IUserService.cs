using LinkifyBLL.ModelView;
using LinkifyDAL.Entities;

namespace LinkifyBLL.Services.Abstraction
{
    public interface IUserService
    {
        Task<bool> RegisterUserAsync(UserRegisterMV user, string password);
        Task<bool> DeleteUserAsync(UserMV user);
        Task<bool> UpdateUserAsync(UserMV oldUser, UserMV newUser);
        Task<bool> ChangeUserPasswordAsync(UserMV user, string oldPassword, string newPassword);
    }
}
