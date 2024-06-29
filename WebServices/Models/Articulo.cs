using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace WebServices.Models
{
    public class Articulo
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio.")]
        [StringLength(100, ErrorMessage = "El nombre no puede tener más de 100 caracteres.")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "La descripción es obligatoria.")]
        [StringLength(500, ErrorMessage = "La descripción no puede tener más de 500 caracteres.")]
        public string Descripcion { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "El stock debe ser un valor positivo.")]
        public int Stock { get; set; }

        [Range(0.01, double.MaxValue, ErrorMessage = "El precio debe ser un valor positivo.")]
        public decimal Precio { get; set; }

        public DateTime Fecha_alta { get; set; }

        public DateTime? Fecha_modificacion { get; set; }

        public DateTime? Fecha_baja { get; set; }

    }
}
