using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Net;
using System.Net.Http;
using WebServices.DTOs.PeliculasDTO;
using WebServices.Middleware;
using WebServices.Models;
using WebServices.Services;

namespace WebServices.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PeliculasController : ControllerBase
    {
        private readonly ApplicationDBContext _context;
        private readonly OmdbService _omdbService;
        private readonly IMapper _mapper;
        private readonly ILogger<ExceptionMiddleware> _logger;

        public PeliculasController(ApplicationDBContext context, OmdbService omdbService, IMapper mapper, ILogger<ExceptionMiddleware> logger)
        {
            _context = context;
            _omdbService = omdbService;
            _mapper = mapper;
            _logger = logger;
        }

        /// <summary>
        /// Búsqueda de películas por título (opcional), año (opcional), criterio de ordenamiento (opcional) y dirección del orden (opcional).
        /// Devuelve una lista de objetos PeliculaDTO con las películas encontradas.
        /// </summary>
        /// <param name="title">Título de la película a buscar (opcional).</param>
        /// <param name="year">Año de estreno de la película a buscar (opcional).</param>
        /// <param name="sort">Criterio de ordenamiento (título o año) - opcional.</param>
        /// <param name="order">Dirección del ordenamiento (ascendente o descendente) - opcional.</param>
        /// <returns>Ok con la lista de películas encontradas o NotFound si no se encuentran películas.</returns>
        [HttpGet("search")]
        public async Task<ActionResult<IEnumerable<PeliculaDTO>>> SearchMovies(string title, int? year, string? sort, string? order)
        {
            try
            {
                var peliculas = await _omdbService.SearchPeliculasAsync(title);

                if (year.HasValue)
                {
                    peliculas = peliculas.Where(m => m.Year == year.Value.ToString()).ToList();
                }

                peliculas = sort switch
                {
                    "title" => order == "asc" ? peliculas.OrderBy(m => m.Title).ToList() : peliculas.OrderByDescending(m => m.Title).ToList(),
                    "year" => order == "asc" ? peliculas.OrderBy(m => m.Year).ToList() : peliculas.OrderByDescending(m => m.Year).ToList(),
                    _ => peliculas
                };

                return Ok(peliculas);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al buscar películas con título {Title}, año {Year}, orden {Sort}, dirección {Order}", title, year, sort, order);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Error interno del servidor. Por favor, consulte el log para más detalles." });
            }
        }

        /// <summary>
        /// Obtiene los detalles de una película por su ID (imdbID).
        /// Devuelve un objeto PeliculaDetalleDTO con los detalles de la película encontrada.
        /// </summary>
        /// <param name="imdbID">ID de la película en IMDB.</param>
        /// <returns>Ok con el objeto PeliculaDetalleDTO o NotFound si no se encuentra la película.</returns>
        [HttpGet("{imdbID}")]
        public async Task<ActionResult<PeliculaDetalleDTO>> GetPeliculaById(string imdbID)
        {
            try
            {
                var resultado = await _omdbService.GetPeliculaByIdAsync(imdbID);
                return resultado != null ? Ok(resultado) : NotFound();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener los detalles de la película con ID {ImdbID}", imdbID);
                return StatusCode((int)HttpStatusCode.InternalServerError, new { message = "Error interno del servidor. Por favor, consulte el log para más detalles." });
            }
        }


    }
}
