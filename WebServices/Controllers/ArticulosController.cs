using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Net;
using WebServices.DTOs.ArticulosDTO;
using WebServices.Migrations;
using WebServices.Models;

namespace WebServices.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ArticulosController : ControllerBase
    {
        private readonly ApplicationDBContext _context;
        private readonly ILogger<ArticulosController> _logger;

        public ArticulosController(ApplicationDBContext context, ILogger<ArticulosController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Obtiene una lista de todos los artículos de la base de datos.
        /// Utiliza un procedimiento almacenado (EXEC PRC_OBTENER_ARTICULOS) para la consulta.
        /// </summary>
        /// <returns>Ok con la lista de artículos o InternalServerError si hay un error.</returns>
        [HttpGet]
        public async Task<IActionResult> GetArticulos()
        {
            try
            {
                var articles = await _context.Articulos.FromSqlRaw("EXEC PRC_OBTENER_ARTICULOS").ToListAsync();
                return Ok(articles);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener los artículos");
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Error interno del servidor. Por favor, consulte el log para más detalles." });
            }
        }

        /// <summary>
        /// Obtiene un artículo específico por su ID.
        /// Utiliza un procedimiento almacenado (EXEC PRC_OBTENER_ARTICULO_ID) para la consulta.
        /// </summary>
        /// <param name="id">ID del artículo a buscar.</param>
        /// <returns>Ok con el artículo encontrado o NotFound si no se encuentra el artículo o InternalServerError si hay un error.</returns>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetArticuloById(int id)
        {
            try
            {
                var result = await _context.Articulos
                    .FromSqlRaw("EXEC PRC_OBTENER_ARTICULO_ID @Id", new SqlParameter("@Id", id))
                    .ToListAsync();

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener el artículo con id {Id}", id);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Error interno del servidor. Por favor, consulte el log para más detalles." });
            }
        }

        /// <summary>
        /// Agrega un nuevo artículo a la base de datos.
        /// Utiliza un procedimiento almacenado (EXEC PRC_AGREGAR_ARTICULO) para la operación.
        /// </summary>
        /// <param name="articulo">Objeto ArticuloEdicionDTO con los datos del artículo a agregar.</param>
        /// <returns>Ok si se agrega el artículo o InternalServerError si hay un error.</returns>
        [HttpPost]
        public async Task<IActionResult> AddArticulo([FromBody] ArticuloEdicionDTO articulo)
        {
            try
            {
                var result = await _context.Database.ExecuteSqlRawAsync(
                    "EXEC PRC_AGREGAR_ARTICULO @Nombre, @Descripcion, @Precio, @Stock",
                    new SqlParameter("@Nombre", articulo.Nombre),
                    new SqlParameter("@Descripcion", articulo.Descripcion),
                    new SqlParameter("@Precio", articulo.Precio),
                    new SqlParameter("@Stock", articulo.Stock)
                );

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al agregar el artículo {Nombre}", articulo.Nombre);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Error interno del servidor. Por favor, consulte el log para más detalles." });
            }
        }

        /// <summary>
        /// Actualiza un artículo existente en la base de datos.
        /// Utiliza un procedimiento almacenado (EXEC PRC_ACTUALIZAR_ARTICULO) para la operación.
        /// </summary>
        /// <param name="id">ID del artículo a actualizar.</param>
        /// <param name="articulo">Objeto ArticuloEdicionDTO con los datos actualizados del artículo.</param>
        /// <returns>Ok si se actualiza el artículo o InternalServerError si hay un error.</returns>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateArticulo(int id, [FromBody] ArticuloEdicionDTO articulo)
        {
            try
            {
                var result = await _context.Database.ExecuteSqlRawAsync(
                    "EXEC PRC_ACTUALIZAR_ARTICULO @Id, @Nombre, @Descripcion, @Precio, @Stock",
                    new SqlParameter("@Id", id),
                    new SqlParameter("@Nombre", articulo.Nombre),
                    new SqlParameter("@Descripcion", articulo.Descripcion),
                    new SqlParameter("@Precio", articulo.Precio),
                    new SqlParameter("@Stock", articulo.Stock)
                );

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al actualizar el artículo con id {Id}", id);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Error interno del servidor. Por favor, consulte el log para más detalles." });
            }
        }

        /// <summary>
        /// Elimina un artículo de la base de datos por su ID.
        /// Utiliza un procedimiento almacenado (EXEC PRC_ELIMINAR_ARTICULO) para la operación.
        /// </summary>
        /// <param name="id">ID del artículo a eliminar.</param>
        /// <returns>Ok si se elimina el artículo o InternalServerError si hay un error.</returns>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteArticulo(int id)
        {
            try
            {
                var result = await _context.Database.ExecuteSqlRawAsync(
                    "EXEC PRC_ELIMINAR_ARTICULO @Id",
                    new SqlParameter("@Id", id)
                );

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al eliminar el artículo con id {Id}", id);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Error interno del servidor. Por favor, consulte el log para más detalles." });
            }
        }

    }
}
