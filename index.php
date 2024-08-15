<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap Demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
  </head>
  <body>
  <nav class="navbar navbar-expand-lg bg-body-tertiary mb-4">
        <div class="container-fluid">
          <a class="navbar-brand" href="#">TU encuesta</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
              <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="#">Home</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="">Ingresar</a>
              </li>
              
          </div>
        </div>
      </nav>
    <div class="container">

      <!-- Main Section -->
      <div class="row mb-4">
        <div class="col-md-6">
          <img src="https://agenciapi.co/sites/default/files/2023-12/sena_doble_titulacion.jpg" class="img-fluid main-img" alt="Sample Image">
        </div>
        <div class="col-md-6">
          <h2>SENA </h2>
          <p>Lorem ipsum, dolor sit amet consectetur adipisicing elit. Voluptate perferendis dolorem soluta illo sunt optio aliquid magni facere officia quam.</p>
          <a href="https://www.sena.edu.co/es-co/Paginas/default.aspx" target="_blank" class="btn btn-primary">IR</a>
        </div>
      </div>

      <!-- Cards Section -->
      <div class="row">
        <div class="col-sm-6 mb-3">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">Usuario Nuevo</h5>
              <p class="card-text">Si todavia no cuentas con una cuenta para poder continuar con nuestra encuesta general por favor dar click
                en el boton que se encutra en la aprte inferiror de color azul, para poder hacer el tramite de registro y continuar llenado la encuetas
              </p>
              <a href="deploy/index.php" class="btn btn-primary">registrate</a>
            </div>
          </div>
        </div>
        <div class="col-sm-6">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">Usuario Antiguo</h5>
              <p class="card-text">si por fortuna ya tienes una cuenta y quieras ingresar y modificar la encuesta por favor dar click en la parte inferior
                del boton de color azul esta bootn te llevara a la parte correspondiente para continuar con el tramite que correpsodne 
              </p>
              <a href="#" class="btn btn-primary">inicar sesion</a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white mt-4">
      <div class="container py-4">
        <div class="row">
          <div class="col-md-6">
            <h5>Sena</h5>
            <p>El SENA esta agradecido por ser participe de esta pagina, espero que pudiste pasarla bien en nuestra encuesta</p>
          </div>
          
        </div>
      </div>
      <div class="bg-secondary text-center py-2">
        <p class="mb-0">© SENA 2024 - Colombia Potencia De Vida </p>
      </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.js"></script>
  </body>
</html>
