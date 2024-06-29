<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Peliculas.aspx.cs" Inherits="sitioWeb.Peliculas" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Material Design for Bootstrap -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.3.2/css/mdb.min.css">

    <!-- Bootstrap js cdn -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            grid-gap: 1rem;
        }
    </style>

    <div class="container">
        <h2 class="text-center">Listado de Películas</h2>
        <div class="row mb-3">
            <div class="col-12 col-md-3 mb-2">
                <label class="form-label" for="searchInput">Título:</label>
                <input type="text" id="searchInput" name="t" class="form-control">
            </div>
            <div class="col-12 col-md-2 mb-2" style="margin-left: 1%">
                <label class="form-label" for="yearInput">Año:</label>
                <input type="text" id="yearInput" name="y" class="form-control">
            </div>
            <div class="col-12 col-md-2 mb-2" style="margin-left: 1%">
                <label class="form-label" for="sortDdl">Ordenar por:</label>
                <div class="custom-select-container">
                    <select id="sortDdl" class="form-select">
                        <option value="year">Año</option>
                        <option value="title">Título</option>
                    </select>
                </div>
            </div>
            <div class="col-12 col-md-2 mb-2" style="margin-left: 1%">
                <label class="form-label" for="orderDdl">Ordenar por:</label>
                <div class="custom-select-container">
                    <select id="orderDdl" class="form-select">
                        <option value="asc">Ascendente</option>
                        <option value="desc">Descendente</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-12">
                <button id="search-by-title-button" type="button" class="btn btn-primary me-2" onclick="buscarPeliculasTitulo()">Buscar</button>
                <button id="search-by-title-reset" type="reset" class="btn btn-secondary" onclick="limpiarCampos()">Limpiar</button>
            </div>
        </div>
        <div id="peliculasContainer" class="row">
        </div>
        <div id="peliculaDetalleContainer" class="row">
        </div>
    </div>

    <!-- Modal para mostrar detalles de la película -->
    <div class="modal fade" id="detallesPeliculaModal" tabindex="-1" aria-labelledby="detallesPeliculaLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="detallesPeliculaTitulo">Detalles de la Película</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="detallesPeliculaContenido"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>


    <script>

        $(document).ready(function () {
            $('#sortDdl').on('change', function () {
                buscarPeliculasTitulo();
            });
            $('#orderDdl').on('change', function () {
                buscarPeliculasTitulo();
            });
        });

        function buscarPeliculasTitulo() {
            var title = $('#searchInput').val();
            var year = $('#yearInput').val();
            var sort = $('#sortDdl').val();
            var order = $('#orderDdl').val();

            if (title.trim() === "") {
                alert("El título no puede estar vacío.");
                return;
            }

            if (year) {
                if (!/^\d{4}$/.test(year)) {
                    alert("El año debe ser un número de cuatro dígitos.");
                    return;
                }
            }

            var params = new URLSearchParams();

            if (title) {
                params.append('title', title);
            }
            if (year) {
                params.append('year', year);
            }
            if (sort) {
                params.append('sort', sort);
            }
            if (order) {
                params.append('order', order);
            }

            $.ajax({
                url: apiUrl + '/api/peliculas/search?' + params.toString(),
                method: 'GET',
                success: function (data) {
                    cargarPeliculas(data);
                },
                error: function (error) {
                    console.log('Error al obtener las películas:', error);
                }
            });
        }


        function limpiarCampos() {
            $('#peliculasContainer').empty();

        }

        function cargarPeliculas(peliculas) {
            var container = $('#peliculasContainer');
            container.empty();

            container.addClass('grid');

            peliculas.forEach(function (pelicula) {
                var card = `
              <div class="card mb-4 grid-item">
                <img src="${pelicula.poster}" class="card-img-top" alt="${pelicula.title}">
                <div class="card-body">
                  <h5 class="card-title">${pelicula.title}</h5>
                  <p class="card-text">Año: ${pelicula.year}</p>
                </div>
                <div>
                  <button id="${pelicula.imdbID}" class="btn btn-primary ver-mas-btn" onClick="verMas('${pelicula.imdbID}')">Ver más</button>
                </div>
              </div>
            `;
                container.append(card);
            });

            $('.ver-mas-btn').on('click', function (event) {
                event.preventDefault();
                var imdbID = $(this).attr('id');
                console.log('Button clicked with ID:', imdbID);
            });
        }

        function verMas(imdbID) {

            $.ajax({
                url: apiUrl + '/api/peliculas/' + imdbID,
                method: 'GET',
                success: function (data) {
                    mostrarDetallesPelicula(data);
                },
                error: function (error) {
                    console.log('Error al obtener los detalles de la película:', error);
                }
            });
        }

        function mostrarDetallesPelicula(pelicula) {
            var detalles = `
                            <div class="text-center d-flex justify-content-center align-items-center">
                              <img src="${pelicula.poster}" class="img-fluid mb-3" alt="${pelicula.title}">
                            </div>
                            <hr>
                            <p class="card-text">Año: ${pelicula.year}</p>
                            <p class="card-text">Calificación: ${pelicula.imdbRating}</p>
                            <p class="card-text">Lanzamiento: ${pelicula.released}</p>
                            <p class="card-text">Duración: ${pelicula.runtime}</p>
                            <p class="card-text">Género: ${pelicula.genre}</p>
                            <p class="card-text">Director: ${pelicula.director}</p>
                            <p class="card-text">Escritor: ${pelicula.writer}</p>
                            <p class="card-text">Actores: ${pelicula.actors}</p>
                            <p class="card-text">Trama: ${pelicula.plot}</p>
                            <p class="card-text">Idioma: ${pelicula.language}</p>
                            <p class="card-text">País: ${pelicula.country}</p>
                            <p class="card-text">Premios: ${pelicula.awards}</p>
                        `;

            $('#detallesPeliculaContenido').html(detalles);

            $('#detallesPeliculaTitulo').text(pelicula.title);

            $('#detallesPeliculaModal').modal('show');
        }



    </script>

</asp:Content>
