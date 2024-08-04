# FaceFusion Windows Installer

This program generates a Windows installer for FaceFusion. Please note that this installer is not officially provided by FaceFusion (https://github.com/facefusion/facefusion).

The installer is created using Inno Setup. For more information on Inno Setup, visit [Inno Setup](https://jrsoftware.org/isinfo.php).

## Important Notice
This version is still in the testing phase, so it may be unstable.

## Post-Installation
After installation, the following three shortcuts will be generated:
![Shortcuts](images/shortcuts.png)

- **FaceFusion**: This will launch the application and start downloading the necessary models.
- **FaceFusion (Skip Download)**: This will launch the application without automatically downloading the models. Instead, it will look for the required models in the `src\.assets\models` directory within the installation directory (default is `C:\FaceFusion` if the default installation path is used). If the models are not found, the application will crash. In this case, you need to download the .onnx models from the [FaceFusion Assets](https://github.com/facefusion/facefusion-assets/releases/tag/models) and manually copy them to the `src\.assets\models` directory.
