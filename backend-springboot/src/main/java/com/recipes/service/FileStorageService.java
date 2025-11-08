package com.recipes.service;

import com.recipes.config.FileStorageConfig;
import com.recipes.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageService {

    private static final Logger log = LoggerFactory.getLogger(FileStorageService.class);
    
    private final Path fileStorageLocation;
    
    // Extensiones permitidas
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    
    // Tamaño máximo: 5MB
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;

    @Autowired
    public FileStorageService(FileStorageConfig fileStorageConfig) {
        this.fileStorageLocation = Paths.get(fileStorageConfig.getUploadDir())
                .toAbsolutePath().normalize();
        
        try {
            Files.createDirectories(this.fileStorageLocation);
            log.info("Directorio de almacenamiento creado: {}", this.fileStorageLocation);
        } catch (Exception ex) {
            throw new RuntimeException("No se pudo crear el directorio de almacenamiento", ex);
        }
    }

    /**
     * Guarda un archivo de imagen en disco
     * @param file El archivo a guardar
     * @return La ruta relativa del archivo guardado (ej: /uploads/recipes/uuid-filename.jpg)
     */
    public String storeFile(MultipartFile file) {
        // Validar que el archivo no esté vacío
        if (file.isEmpty()) {
            throw new IllegalArgumentException("No se puede almacenar un archivo vacío");
        }
        
        // Validar tamaño
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("El archivo excede el tamaño máximo permitido (5MB)");
        }
        
        // Obtener nombre original y normalizar
        String originalFileName = StringUtils.cleanPath(file.getOriginalFilename());
        
        // Validar extensión
        String extension = getFileExtension(originalFileName);
        if (!isAllowedExtension(extension)) {
            throw new IllegalArgumentException("Tipo de archivo no permitido. Solo se aceptan: jpg, jpeg, png, gif, webp");
        }
        
        try {
            // Validar que no contenga caracteres inválidos
            if (originalFileName.contains("..")) {
                throw new IllegalArgumentException("El nombre del archivo contiene una secuencia de ruta inválida");
            }
            
            // Generar nombre único para evitar colisiones
            String fileName = UUID.randomUUID().toString() + extension;
            
            // Copiar archivo al directorio de destino
            Path targetLocation = this.fileStorageLocation.resolve(fileName);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
            
            // Retornar ruta relativa que se guardará en BD
            String relativePath = "/uploads/recipes/" + fileName;
            log.info("Archivo guardado exitosamente: {}", relativePath);
            
            return relativePath;
            
        } catch (IOException ex) {
            throw new RuntimeException("No se pudo almacenar el archivo " + originalFileName, ex);
        }
    }

    /**
     * Carga un archivo como Resource para servirlo
     * @param fileName Nombre del archivo
     * @return Resource del archivo
     */
    public Resource loadFileAsResource(String fileName) {
        try {
            Path filePath = this.fileStorageLocation.resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());
            
            if (resource.exists()) {
                return resource;
            } else {
                throw new ResourceNotFoundException("Archivo no encontrado: " + fileName);
            }
        } catch (MalformedURLException ex) {
            throw new ResourceNotFoundException("Archivo no encontrado: " + fileName);
        }
    }

    /**
     * Elimina un archivo del disco
     * @param filePath Ruta relativa del archivo (ej: /uploads/recipes/uuid-filename.jpg)
     * @return true si se eliminó exitosamente
     */
    public boolean deleteFile(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return false;
        }
        
        try {
            // Extraer solo el nombre del archivo de la ruta
            String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
            Path file = this.fileStorageLocation.resolve(fileName).normalize();
            
            boolean deleted = Files.deleteIfExists(file);
            if (deleted) {
                log.info("Archivo eliminado: {}", filePath);
            }
            return deleted;
            
        } catch (IOException ex) {
            log.error("Error al eliminar archivo: {}", filePath, ex);
            return false;
        }
    }
    
    /**
     * Obtiene la extensión del archivo
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
    }
    
    /**
     * Verifica si la extensión es permitida
     */
    private boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }
}
