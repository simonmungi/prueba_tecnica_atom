namespace WebServices.DTOs.PeliculasDTO
{
    public class OmdbSearchResultDTO
    {
        public List<PeliculaDTO> Search { get; set; }
        public string TotalResults { get; set; }
        public string Response { get; set; }
    }

}
