using LinkifyBLL.Services.Abstraction;
using LinkifyBLL.Services.Implementation;
using LinkifyDAL.DataBase;
using LinkifyDAL.Entities;
using LinkifyDAL.Repo.Abstraction;
using LinkifyDAL.Repo.Implementation;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SolrNet;

namespace LinkifyBLL.Services.Static
{
    public static class ServiceExtensions
    {
        public static void LinkifyIdentity(this IServiceCollection services)
        {
            services.AddIdentity<User, IdentityRole>(options =>
            {
                options.SignIn.RequireConfirmedAccount = false;
                options.Password.RequireDigit = true;
                options.Password.RequireLowercase = true;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = true;
                options.Password.RequiredLength = 8;
            })
            .AddEntityFrameworkStores<LinkifyDbContext>()
            .AddDefaultTokenProviders();
        }

        public static void LinkifyUserDependencyInjection(this IServiceCollection services) { 
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IAuthenticationService, AuthenticationService>();
        }

        public static void LinkifyEnhancedConnectionString(this IServiceCollection services, IConfiguration configuration, string stringName = "defaultConnection")
        {
            var connectionString = configuration.GetConnectionString(stringName);
            services.AddDbContext<LinkifyDbContext>(options =>
                options.UseSqlServer(connectionString));
        }
    }
}
