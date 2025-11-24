
$(document).ready(function () {
    const path = window.location.pathname.split("/").pop().toLowerCase();

    $(".sidebar nav .nav-link").each(function () {
        const href = $(this).attr("href").split("/").pop().toLowerCase();

        if (href === path) {
            $(this).addClass("active-link");
        } else {
            $(this).removeClass("active-link");
        }
    });
});

function deleteUser(id) {
    if (!confirm("¿Deseas eliminar al usuario con ID " + id + "?")) {
        return;
    }

    fetch(`http://localhost:8080/usuarios/${id}`, {
        method: "DELETE"
    })
    .then(r => r.text())
    .then(msg => {
        alert(msg);
        document.querySelector(`tr[data-id="${id}"]`).remove();
    })
    .catch(err => console.error("Error:", err));
}

function verDetalles(id) {

    fetch(`http://localhost:8080/usuarios/${id}`)
        .then(res => res.json())
        .then(data => {

            document.getElementById("det-id").textContent = data.id;
            document.getElementById("det-nombre").textContent = data.nombre;
            document.getElementById("det-email").textContent = data.email;
            document.getElementById("det-pais").textContent = data.pais;
            document.getElementById("det-fecha").textContent = data.fechaRegistro;

            var modal = new bootstrap.Modal(
                document.getElementById('detalleUsuarioModal')
            );

            modal.show();
        })
        .catch(err => {
            console.error(err);
            alert("No se pudo cargar la información del usuario.");
        });
}
