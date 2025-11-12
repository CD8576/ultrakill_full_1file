# Use official .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

# Copy your project file first
COPY ULTRAKILL_FULL_GAME.csproj .
RUN dotnet restore

# Install dependencies and download Unity managed assemblies
RUN apt-get update && apt-get install -y wget tar && \
    mkdir -p /unity-libs && \
    echo "Downloading Unity Editor..." && \
    wget -q https://download.unity3d.com/download_unity/9b9180224413/LinuxEditorInstaller/Unity.tar.xz -O /tmp/unity.tar.xz && \
    mkdir -p /tmp/unity && tar -xf /tmp/unity.tar.xz -C /tmp/unity && \
    echo "Copying Unity managed DLLs..." && \
    cp -r /tmp/unity/Editor/Data/Managed/*.dll /unity-libs/ || true && \
    cp -r /tmp/unity/Editor/Data/Managed/UnityEngine/*.dll /unity-libs/ || true && \
    rm -rf /tmp/unity /tmp/unity.tar.xz && \
    echo "Unity DLLs ready!"

# Copy all source files
COPY . .

# Build with full Unity references
RUN dotnet build -c Release -o /app/build \
    /p:ReferencePath=/unity-libs

ENTRYPOINT ["dotnet", "/app/build/ULTRAKILL_FULL_GAME.dll"]
