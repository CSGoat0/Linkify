using Microsoft.AspNetCore.Http;

namespace SempaBLL.Helper
{
    public static class FileManager
    {
        public static string UploadFile(string FolderName, IFormFile File)
        {
            try
            {
                // Create folder if it doesn't exist
                string FolderPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", FolderName);
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }

                // Generate unique filename
                string FileName = Guid.NewGuid() + Path.GetExtension(File.FileName);
                string FinalPath = Path.Combine(FolderPath, FileName);

                using (var Stream = new FileStream(FinalPath, FileMode.Create))
                {
                    File.CopyTo(Stream);
                }

                // Return relative path including folder
                return $"/{FolderName}/{FileName}";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public static string RemoveFile(string FolderName, string fileName)
        {
            try
            {
                // Remove leading / if present
                if (fileName.StartsWith("/"))
                {
                    fileName = fileName.Substring(1);
                }

                var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", fileName);

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                    return "File Deleted";
                }
                return "File Not Found";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
    }
}
