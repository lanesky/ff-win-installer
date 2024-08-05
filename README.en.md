[![中](https://img.shields.io/badge/lang-中-red.svg)](https://github.com/lanesky/ff-win-installer/blob/master/README.md)
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/lanesky/ff-win-installer/blob/master/README.en.md)

# FaceFusion Windows Installer

This program generates a Windows installer for FaceFusion. Please note that this installer is not officially provided by FaceFusion (https://github.com/facefusion/facefusion).

The installer is created using Inno Setup. For more information on Inno Setup, visit [Inno Setup](https://jrsoftware.org/isinfo.php).

## Important Notice
1. **Unofficial Installer**
   This tool is not an official Windows installer provided by FaceFusion (https://github.com/facefusion/facefusion).

2. **Testing Phase**
   This installer is still in the testing phase, so it may be unstable.

3. **Technical Skill Requirement**
   Although this installer can be used to install FaceFusion on Windows systems, please note that the installation environment on Windows can be quite complex. Users of this installer should have a certain level of technical ability to handle potential issues. Therefore, using the official FaceFusion installer might be a better choice for general users.

## Post-Installation
After installation, the following three shortcuts will be generated:

<img src="images/shortcuts.png" alt="Shortcuts" width="500"/>

- **FaceFusion**: This will launch the application and start downloading the necessary models.
- **FaceFusion (Skip Download)**: This will launch the application without automatically downloading the models. Instead, it will look for the required models in the `src\.assets\models` directory within the installation directory (default is `C:\FaceFusion` if the default installation path is used). If the models are not found, the application will crash. In this case, you need to download the .onnx models from the [FaceFusion Assets](https://github.com/facefusion/facefusion-assets/releases/tag/models) and manually copy them to the `src\.assets\models` directory.
