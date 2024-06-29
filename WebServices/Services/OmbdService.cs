using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using WebServices.DTOs.PeliculasDTO;
using WebServices.Models;

namespace WebServices.Services
{
    public class OmdbService
    {
        private readonly HttpClient _httpClient;
        public IConfiguration Configuration;
        private readonly string _apiKey;

        public OmdbService(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _apiKey = configuration["ApiKeys:omdbapikey"];
        }

        public async Task<List<PeliculaDTO>> SearchPeliculasAsync(string title)
        {
            var response = await _httpClient.GetStringAsync($"https://www.omdbapi.com/?s={title}&plot=short&apikey={_apiKey}");
            var searchResult = JsonConvert.DeserializeObject<OmdbSearchResultDTO>(response);

            return searchResult?.Search ?? new List<PeliculaDTO>();
        }

        public async Task<PeliculaDetalleDTO> GetPeliculaByIdAsync(string imdbID)
        {
            var response = await _httpClient.GetStringAsync($"https://www.omdbapi.com/?i={imdbID}&apikey={_apiKey}");
            var pelicula = JsonConvert.DeserializeObject<PeliculaDetalleDTO>(response);
            return pelicula;
        }

    }
}
