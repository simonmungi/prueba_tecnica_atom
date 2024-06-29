using Microsoft.EntityFrameworkCore;
using WebServices.Models;

namespace WebServices
{
    public class ApplicationDBContext : DbContext
    {
        public ApplicationDBContext(DbContextOptions options) : base(options)
        {
        }

        public DbSet<Articulo> Articulos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Articulo>()
                .Property(a => a.Precio)
                .HasColumnType("decimal(18,2)");

            base.OnModelCreating(modelBuilder);
        }

    }
}
