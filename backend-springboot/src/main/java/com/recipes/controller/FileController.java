package com.recipes.controller;

import com.recipes.service.FileStorageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/files")
@CrossOrigin(origins = "*")
public class FileController {

    private static final Logger log = LoggerFactory.getLogger(FileController.class);

    @Autowired
    private FileStorageService fileStorageService;

    /**
     * Endpoint para subir una imagen
     * POST /api/files/upload
     * 
     * @param file El archivo multipart a subir
     * @return JSON con la ruta del archivo guardado
     */
    @PostMapping("/upload")
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            String filePath = fileStorageService.storeFile(file);
            
            Map<String, String> response = new HashMap<>();
            response.put("fileName", file.getOriginalFilename());
            response.put("filePath", filePath);
            response.put("fileSize", String.valueOf(file.getSize()));
            response.put("message", "Archivo subido exitosamente");
            
            return ResponseEntity.ok(response);
            
        } catch (IllegalArgumentException e) {
            log.warn("Error de validación al subir archivo: {}", e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
            
        } catch (Exception e) {
            log.error("Error al subir archivo", e);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al subir el archivo: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Endpoint para descargar/ver una imagen
     * GET /api/files/download/{fileName}
     * 
     * @param fileName Nombre del archivo a descargar
     * @param request HttpServletRequest para determinar el tipo de contenido
     * @return El archivo como Resource
     */
    @GetMapping("/download/{fileName:.+}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName, HttpServletRequest request) {
        try {
            // Cargar archivo como Resource
            Resource resource = fileStorageService.loadFileAsResource(fileName);
            
            // Determinar tipo de contenido
            String contentType = null;
            try {
                contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
            } catch (IOException ex) {
                log.info("No se pudo determinar el tipo de archivo.");
            }
            
            // Por defecto usar application/octet-stream
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                    .body(resource);
                    
        } catch (Exception e) {
            log.error("Error al descargar archivo: {}", fileName, e);
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * Endpoint para servir imágenes directamente (sin forzar descarga)
     * GET /api/files/images/{fileName}
     * Útil para mostrar imágenes en <img> tags
     */
    @GetMapping("/images/{fileName:.+}")
    public ResponseEntity<Resource> serveImage(@PathVariable String fileName) {
        try {
            Resource resource = fileStorageService.loadFileAsResource(fileName);
            
            // Determinar tipo MIME de la imagen
            String contentType = "image/jpeg"; // Por defecto
            String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            
            switch (extension) {
                case "png":
                    contentType = "image/png";
                    break;
                case "gif":
                    contentType = "image/gif";
                    break;
                case "webp":
                    contentType = "image/webp";
                    break;
                case "jpg":
                case "jpeg":
                default:
                    contentType = "image/jpeg";
                    break;
            }
            
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
                    
        } catch (Exception e) {
            log.error("Error al servir imagen: {}", fileName, e);
            return ResponseEntity.notFound().build();
        }
    }
}
