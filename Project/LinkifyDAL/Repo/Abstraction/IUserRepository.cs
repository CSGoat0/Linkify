using LinkifyDAL.Entities;
using Microsoft.AspNetCore.Identity;
namespace LinkifyDAL.Repo.Abstraction
{
    public interface IUserRepository
    {
        Task<bool> RegisterUserAsync(User user, string password);
        Task<bool> DeleteUserAsync(User user);
        Task<bool> ChangeUserPasswordAsync(User user, string oldPassword, string newPassword);
        Task<IdentityResult> UpdateUserAsync(User user);
        Task<User> FindByEmailAsync(string email);
        Task<bool> CheckPasswordAsync(User user, string password);
    }
}
