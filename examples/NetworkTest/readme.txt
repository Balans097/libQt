

nim cpp --passC:"-std=c++20" --passC:"$(pkg-config --cflags Qt6Core Qt6Network)" --passL:"$(pkg-config --libs Qt6Core Qt6Network)" test_nimQtNetwork.nim


