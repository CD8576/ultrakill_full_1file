# Use official .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

# Copy your project files
COPY ULTRAKILL_FULL_GAME.csproj .
RUN dotnet restore

# Download minimal Unity managed libraries (for compilation)
RUN apt-get update && apt-get install -y wget unzip && \
    mkdir -p /unity-libs && \
    wget -q https://download.unity3d.com/download_unity/9b9180224413/LinuxEditorInstaller/Unity.tar.xz -O /tmp/unity.tar.xz && \
    mkdir -p /tmp/unity && tar -xf /tmp/unity.tar.xz -C /tmp/unity && \
    cp -r /tmp/unity/Editor/Data/Managed/UnityEngine* /unity-libs/ || true && \
    rm -rf /tmp/unity /tmp/unity.tar.xz

# Copy the rest of your source code
COPY . .

# Build the project (just compiles; doesn’t run Unity)
RUN dotnet build -c Release -o /app/build

ENTRYPOINT ["dotnet", "/app/build/ULTRAKILL_FULL_GAME.dll"]
