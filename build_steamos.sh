#!/bin/bash
set -e

# Clean and prepare directories
rm -rf linux
mkdir -p linux/x86
mkdir -p linux/x86_64
mkdir -p linux/lobby_connect
mkdir -p linux/tools
mkdir -p linux/experimental/x86
mkdir -p linux/experimental/x86_64

# Copy scripts
cp scripts/find_interfaces.sh linux/tools/
cp scripts/steamclient_loader.sh linux/tools/

# Generate protobuf files (32-bit)
../protobuf/prefix_x86/bin/protoc -I./dll/ --cpp_out=./dll/ ./dll/*.proto

## Build 32-bit binaries
#g++ -m32 -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DNDEBUG -DCONTROLLER_SUPPORT -s \
#	-o linux/x86/libsteam_api.so \
#	dll/*.cpp dll/*.cc controller/*.c \
#	-Wno-return-type \
#	-I../protobuf/prefix_x86/include/ \
#	-L../protobuf/prefix_x86/lib/ \
#	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built32

#g++ -m32 -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DNDEBUG -DNO_DISK_WRITES -DLOBBY_CONNECT -s \
#	-o linux/lobby_connect/lobby_connect_x86 \
#	lobby_connect.cpp dll/*.cpp dll/*.cc \
#	-Wno-return-type \
#	-I../protobuf/prefix_x86/include/ \
#	-L../protobuf/prefix_x86/lib/ \
#	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built_lobby_connect32

#g++ -m32 -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DSTEAMCLIENT_DLL -DNDEBUG -DCONTROLLER_SUPPORT -s \
#	-o linux/x86/steamclient.so \
#	dll/*.cpp dll/*.cc controller/*.c \
#	-Wno-return-type \
#	-I../protobuf/prefix_x86/include/ \
#	-L../protobuf/prefix_x86/lib/ \
#	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built32_steamclient

## Build 32-bit experimental binaries
#g++ -m32 -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DEMU_EXPERIMENTAL_BUILD -DNDEBUG -DCONTROLLER_SUPPORT -DEMU_OVERLAY -s \
#	-o linux/experimental/x86/libsteam_api.so \
#	dll/*.cpp dll/*.cc controller/*.c \
#	ImGui/*.cpp ImGui/backends/imgui_impl_x11.cpp ImGui/backends/imgui_impl_vulkan.cpp ImGui/backends/imgui_impl_opengl3.cpp \
#	overlay_experimental/*.cpp overlay_experimental/linux/*.cpp overlay_experimental/System/*.cpp \
#	-Wno-return-type \
#	-IImGui -Ioverlay_experimental \
#	-I../protobuf/prefix_x86/include/ \
#	-L../protobuf/prefix_x86/lib/ \
#	-lGL -lX11 -lXext -lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built32

#g++ -m32 -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DEMU_EXPERIMENTAL_BUILD -DSTEAMCLIENT_DLL -DNDEBUG -DCONTROLLER_SUPPORT -s \
#	-o linux/experimental/x86/steamclient.so \
#	dll/*.cpp dll/*.cc controller/*.c \
#	-Wno-return-type \
#	-I../protobuf/prefix_x86/include/ \
#	-L../protobuf/prefix_x86/lib/ \
#	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built32_steamclient

# Generate protobuf files (64-bit)
../protobuf/prefix/bin/protoc -I./dll/ --cpp_out=./dll/ ./dll/*.proto

# Build 64-bit binaries
#g++ -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DNDEBUG -DCONTROLLER_SUPPORT -s \
#	-o linux/x86_64/libsteam_api.so \
#	dll/*.cpp dll/*.cc controller/*.c \
#	-Wno-return-type \
#	-I../protobuf/prefix/include/ \
#	-L../protobuf/prefix/lib/ \
#	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built64

#g++ -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DNDEBUG -DNO_DISK_WRITES -DLOBBY_CONNECT -s \
#	-o linux/lobby_connect/lobby_connect_x64 \
#	lobby_connect.cpp dll/*.cpp dll/*.cc \
#	-Wno-return-type \
#	-I../protobuf/prefix/include/ \
#	-L../protobuf/prefix/lib/ \
#	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built_lobby_connect64

#g++ -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
#	-DGNUC -DEMU_RELEASE_BUILD -DSTEAMCLIENT_DLL -DNDEBUG -DCONTROLLER_SUPPORT -s \
#	-o linux/x86_64/steamclient.so \
#	dll/*.cpp dll/*.cc controller/*.c \
#	-Wno-return-type \
#	-I../protobuf/prefix/include/ \
#	-L../protobuf/prefix/lib/ \
#	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built64_steamclient

# Build 64-bit experimental binaries
g++ -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
	-DGNUC -DEMU_RELEASE_BUILD -DEMU_EXPERIMENTAL_BUILD -DCONTROLLER_SUPPORT -DEMU_OVERLAY -s \
	-o linux/experimental/x86_64/libsteam_api.so \
	dll/*.cpp dll/*.cc controller/*.c \
	ImGui/*.cpp ImGui/backends/imgui_impl_x11.cpp ImGui/backends/imgui_impl_vulkan.cpp ImGui/backends/imgui_impl_opengl3.cpp \
	overlay_experimental/*.cpp overlay_experimental/linux/*.cpp overlay_experimental/System/*.cpp \
	-Wno-return-type \
	-IImGui -Ioverlay_experimental \
	-I../protobuf/prefix/include/ \
	-L../protobuf/prefix/lib/ \
	-lGL -lX11 -lXext -lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built64

g++ -shared -fPIC -fvisibility=hidden -Wl,--exclude-libs,ALL \
	-DGNUC -DEMU_RELEASE_BUILD -DEMU_EXPERIMENTAL_BUILD -DSTEAMCLIENT_DLL -DCONTROLLER_SUPPORT -s \
	-o linux/experimental/x86_64/steamclient.so \
	dll/*.cpp dll/*.cc controller/*.c \
	-Wno-return-type \
	-I../protobuf/prefix/include/ \
	-L../protobuf/prefix/lib/ \
	-lprotobuf -lprotobuf-lite -lpthread -ldl -std=c++14 && echo built64_steamclient
