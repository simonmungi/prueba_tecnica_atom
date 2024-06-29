<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Articulos.aspx.cs" Inherits="sitioWeb.Articulos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <!-- Material Design for Bootstrap -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.3.2/css/mdb.min.css">

    <!-- Bootstrap js cdn -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.css">

    <style>
        .modal-text-area {
            min-height: 200px;
            width: 100%;
            resize: none;
            overflow: auto;
        }
    </style>
    <script>

        $(document).ready(function () {

            cargarGrillaPrincipal();
        });

        function agregarArticulo() {
            $('#addModal').modal('show');

        }

        function limpiarCampos() {
            $('#editNombre').val('');
            $('#editDescripcion').val('');
            $('#editPrecio').val('');
            $('#addNombre').val('');
            $('#addDescripcion').val('');
            $('#addPrecio').val('');
            $('#addStock').val('');
        }

        function guardarCambiosAdd() {
            var nombre = $('#addNombre').val().trim();
            var descripcion = $('#addDescripcion').val().trim();
            var precio = $('#addPrecio').val();
            var stock = $('#addStock').val();

            var isValid = true;
            var mensajeValidacion = "";

            if (!nombre) {
                isValid = false;
                mensajeValidacion += "El nombre del artículo es obligatorio.\n";
            }

            if (!descripcion) {
                isValid = false;
                mensajeValidacion += "La descripción del artículo es obligatoria.\n";
            }

            if (!isNaN(precio) && precio > 0) {
            } else {
                isValid = false;
                mensajeValidacion += "El precio debe ser un número positivo.\n";
            }

            if (!isNaN(stock) && stock > 0) {
            } else {
                isValid = false;
                mensajeValidacion += "El stock debe ser un número positivo.\n";
            }

            if (!isValid) {
                alert(mensajeValidacion);
                return;
            }

            var articulo = {
                nombre: nombre,
                descripcion: descripcion,
                stock: stock,
                precio: precio
            };

            $.ajax({
                url: apiUrl + '/api/articulos',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(articulo),
                success: function () {
                    $('#addModal').modal('hide');
                    cargarGrillaPrincipal();
                },
                error: function (error) {
                    alert("Hubo un error al crear el artículo.");
                    console.log('Error al crear el artículo:', error);
                    $('#addModal').modal('hide');
                }
            });
        }

        function EditarArticulo(id) {

            $.ajax({
                url: apiUrl + '/api/articulos/' + id,
                method: 'GET',
                success: function (data) {
                    $('#editId').val(data[0].id);
                    $('#editNombre').val(data[0].nombre);
                    $('#editDescripcion').val(data[0].descripcion);
                    $('#editPrecio').val(data[0].precio);
                    $('#editStock').val(data[0].stock);
                    $('#editModal').modal('show');
                },
                error: function (error) {
                    alert("Hubo un error al editar el artículo.");
                    console.log('Error al obtener el artículo:', error);
                }
            });
            return false;
        }

        function guardarCambiosEdit() {
            var id = $('#editId').val();
            var nombre = $('#editNombre').val().trim();
            var descripcion = $('#editDescripcion').val().trim();
            var precio = $('#editPrecio').val();
            var stock = $('#editStock').val();

            var isValid = true;
            var mensajeValidacion = "";

            if (!nombre) {
                isValid = false;
                mensajeValidacion += "El nombre del artículo es obligatorio.\n";
            }

            if (!descripcion) {
                isValid = false;
                mensajeValidacion += "La descripción del artículo es obligatoria.\n";
            }

            if (!isNaN(precio) && precio > 0) {
            } else {
                isValid = false;
                mensajeValidacion += "El precio debe ser un número positivo.\n";
            }


            if (!isNaN(stock) && stock > 0) {
            } else {
                isValid = false;
                mensajeValidacion += "El stock debe ser un número positivo.\n";
            }

            if (!isValid) {
                alert(mensajeValidacion);
                return;
            }

            var articulo = {
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                stock: stock
            };

            $.ajax({
                url: apiUrl + '/api/articulos/' + id,
                method: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(articulo),
                success: function () {
                    $('#editModal').modal('hide');
                    cargarGrillaPrincipal();
                },
                error: function (error) {
                    alert("Hubo un error al guardar el artículo.");
                    console.log('Error al actualizar el artículo:', error);
                    $('#editModal').modal('hide');
                }
            });
        }

        function EliminarArticulo(id) {
            if (confirm('¿Estás seguro de que deseas eliminar este artículo?')) {
                $.ajax({
                    url: apiUrl + '/api/articulos/' + id,
                    method: 'DELETE',
                    success: function () {
                        cargarGrillaPrincipal();
                    },
                    error: function (error) {
                        alert("Hubo un error al eliminar el artículo.");
                        console.log('Error al eliminar el artículo:', error);
                    }
                });
            }
            return false;
        }

        function VerDescripcion(descripcion) {
            $('#modalTextArea').text(descripcion);
            $('#textModal').modal('show');

            return false;
        }

        function cargarGrillaPrincipal() {
            limpiarCampos();
            $.ajax({
                url: apiUrl + '/api/articulos',
                method: 'GET',
                success: function (data) {

                    if ($.fn.DataTable.isDataTable('#articulosTable')) {
                        $('#articulosTable').DataTable().clear().destroy();
                    }

                    let table = $('#articulosTable').DataTable(
                        {
                            "language": {
                                "url": "//cdn.datatables.net/plug-ins/1.10.12/i18n/Spanish.json",
                                "lengthMenu": "Mostrando _MENU_ filas por página",
                                "zeroRecords": "Ningún dato disponible",
                                "info": "Mostrando _START_ a _END_ de _TOTAL_ registros",
                                "infoEmpty": "",

                                "search": "Buscar:",
                                "infoFiltered": " (filtrado de _MAX_ registros) "
                            },
                            columnDefs: [
                                {
                                    targets: '[data-column="date"]',
                                    render: function (data, type, row) {
                                        var date = new Date(data);
                                        var day = String(date.getDate()).padStart(2, '0');
                                        var month = String(date.getMonth() + 1).padStart(2, '0'); // Months are 0-indexed
                                        var year = date.getFullYear();
                                        var hours = date.getHours().toString().padStart(2, '0');
                                        var minutes = date.getMinutes().toString().padStart(2, '0');

                                        return day + '-' + month + '-' + year + ' ' + hours + ':' + minutes;
                                    }
                                },
                                {
                                    targets: '[data-column="money"]',
                                    render: function (data, type, row) {
                                        return parseFloat(data).toLocaleString('es-AR', { style: 'currency', currency: 'ARS' });
                                    },
                                    className: 'text-center'
                                },
                                { targets: '[data-column="button"]', className: 'text-center' }
                            ]
                        }
                    );

                    table.clear();

                    data.forEach(function (item) {

                        let btnEditar = `
                                        <button type="button" class="btn btn-primary" onclick="return EditarArticulo(` + "'" + item.id + "'" + `)">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-fill" viewBox="0 0 16 16">
                                            <path d="M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.5.5 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11z"/>
                                            </svg>
                                        </button>
                                    `;

                        let btnEliminar = `
                                        <button type="button" class="btn btn-danger" onclick="return EliminarArticulo(` + "'" + item.id + "'" + `)">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                                                <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5M8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5m3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0"/>
                                            </svg>
                                        </button>
                                    `;

                        let btnVer = `
                                        <button type="button" class="btn btn-warning" onclick="return VerDescripcion(` + "'" + item.descripcion + "'" + `)">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16">
                                                <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0"/>
                                                <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8m8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7"/>
                                            </svg>
                                        </button>
                                    `;

                        table.row.add([
                            item.nombre,
                            item.stock,
                            btnVer,
                            item.precio,
                            item.fecha_alta,
                            btnEditar,
                            btnEliminar
                        ]).draw();

                    });
                },
                error: function (error) {
                    alert("Hubo un error al obtener los artículos.");
                    console.log('Error al obtener los artículos:', error);
                }
            });
        }
    </script>

    <div class="container">
        <h1 class="text-center">Artículos</h1>
        <div class="table-responsive">
            <table id="articulosTable" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th>Stock</th>
                        <th data-column="button">Descripción</th>
                        <th data-column="money">Precio</th>
                        <th data-column="date">Fecha alta</th>
                        <th data-column="button">Modificar</th>
                        <th data-column="button">Eliminar</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>

    <!-- Modal Editar-->
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel">Editar Artículo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editForm">
                        <input type="hidden" id="editId" />
                        <div class="mb-3">
                            <label for="editNombre" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="editNombre" required />
                        </div>
                        <div class="mb-3">
                            <label for="editDescripcion" class="form-label">Descripción</label>
                            <input type="text" class="form-control" id="editDescripcion" required />
                        </div>
                        <div class="mb-3">
                            <label for="editPrecio" class="form-label">Precio</label>
                            <input type="number" class="form-control" id="editPrecio" required />
                        </div>
                        <div class="mb-3">
                            <label for="editStock" class="form-label">Stock</label>
                            <input type="number" class="form-control" id="editStock" required />
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary" onclick="guardarCambiosEdit()">Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Agregar-->
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addModalLabel">Agregar Artículo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addForm">
                        <input type="hidden" id="addId" />
                        <div class="mb-3">
                            <label for="addNombre" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="addNombre" required />
                        </div>
                        <div class="mb-3">
                            <label for="addDescripcion" class="form-label">Descripción</label>
                            <input type="text" class="form-control" id="addDescripcion" required />
                        </div>
                        <div class="mb-3">
                            <label for="addPrecio" class="form-label">Precio</label>
                            <input type="number" class="form-control" id="addPrecio" required />
                        </div>
                        <div class="mb-3">
                            <label for="addStock" class="form-label">Stock</label>
                            <input type="number" class="form-control" id="addStock" required />
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary" onclick="guardarCambiosAdd()">Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Descripción-->
    <div class="modal fade" id="textModal" tabindex="-1" aria-labelledby="textModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="textModalLabel">Descripción</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center d-flex justify-content-center align-items-center">
                        <textarea class="modal-text-area" id="modalTextArea" readonly></textarea>
                    </div>
                </div>




                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-3">
        <button type="button" class="btn btn-success" id="btnAgregarArticulo" onclick="agregarArticulo()">
            Agregar 
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle-fill" viewBox="0 0 16 16">
            <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3z"></path>
        </svg>
        </button>
    </div>


</asp:Content>
