using LinkifyDAL.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
namespace LinkifyDAL.DataBase
{
    public class LinkifyDbContext: IdentityDbContext
    {
        public LinkifyDbContext(DbContextOptions<LinkifyDbContext> options) : base(options)
        { }
        public DbSet<User> User { get; set; }
    }
}
