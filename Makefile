SRC_DIR = src
BUILD_DIR = target
BIN = ray-tracing

# CXX = clang++

# Use modern C++ standard
CXXFLAGS += -std=c++17

# Strict warnings
CXXFLAGS += -Wall -Wextra

# Generate dependency rules (*.d files)
CXXFLAGS += -MMD -MP

# Debug flags
CXXFLAGS_DBG = $(CXXFLAGS) -g

# Release flags
CXXFLAGS_REL = $(CXXFLAGS) -O3

SRCS = $(wildcard $(SRC_DIR)/*.cpp)

.PHONY: build
build: build-debug

.PHONY: run
run: run-debug

.PHONY: clean
clean:
	@echo "Removing $(BUILD_DIR): rm -rf $(BUILD_DIR)" >&2 
	@rm -rf $(BUILD_DIR)

###########
# Debug   #
###########

BUILD_DIR_DBG = $(BUILD_DIR)/debug
OBJS_DBG = $(SRCS:%.cpp=$(BUILD_DIR_DBG)/%.o)
DEPS_DBG = $(OBJS_DBG:%.o=%.d)

.PHONY: build-debug
build-debug: $(BUILD_DIR_DBG)/$(BIN)

$(BUILD_DIR_DBG)/$(BIN): $(OBJS_DBG)
	@mkdir -p $(@D)
	@echo "Linking $@: $(CXX) $(CXXFLAGS_DBG) $^ -o $@" >&2
	@$(CXX) $(CXXFLAGS_DBG) $^ -o $@

$(BUILD_DIR_DBG)/%.o: %.cpp
	@mkdir -p $(@D)
	@echo "Building $@: $(CXX) $(CXXFLAGS_DBG) -c $< -o $@" >&2
	@$(CXX) $(CXXFLAGS_DBG) -c $< -o $@

# Include generated dependency rules (*.d files)
-include $(DEPS_DBG)

.PHONY: run-debug
run-debug: $(BUILD_DIR_DBG)/$(BIN)
	@$(BUILD_DIR_DBG)/$(BIN)

.PHONY: clean-debug
clean-debug:
	@echo "Removing $(BUILD_DIR_DBG): rm -rf $(BUILD_DIR_DBG)" >&2 
	@rm -rf $(BUILD_DIR_DBG)

###########
# Release #
###########

BUILD_DIR_REL = $(BUILD_DIR)/release
OBJS_REL = $(SRCS:%.cpp=$(BUILD_DIR_REL)/%.o)
DEPS_REL = $(OBJS_REL:%.o=%.d)

.PHONY: build-release
build-release: $(BUILD_DIR_REL)/$(BIN)

$(BUILD_DIR_REL)/$(BIN): $(OBJS_REL)
	@mkdir -p $(@D)
	@echo "Linking $@: $(CXX) $(CXXFLAGS_REL) $^ -o $@" >&2
	@$(CXX) $(CXXFLAGS_REL) $^ -o $@

$(BUILD_DIR_REL)/%.o: %.cpp
	@mkdir -p $(@D)
	@echo "Building $@: $(CXX) $(CXXFLAGS_REL) -c $< -o $@" >&2 
	@$(CXX) $(CXXFLAGS_REL) -c $< -o $@

# Include generated dependency rules (*.d files)
-include $(DEPS_REL)

.PHONY: run-release
run-release: $(BUILD_DIR_REL)/$(BIN)
	@$(BUILD_DIR_REL)/$(BIN)

.PHONY: clean-release
clean-release:
	@echo "Removing $(BUILD_DIR_REL): rm -rf $(BUILD_DIR_REL)" >&2 
	@rm -rf $(BUILD_DIR_REL)
