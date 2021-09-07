#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
REF_DIR   = .
SRC_DIR   = $(REF_DIR)/src
INC_DIR   = $(REF_DIR)/include
LIB_DIR   = $(REF_DIR)/lib
OBJ_DIR   = $(REF_DIR)/build
TRG_DIR   = $(REF_DIR)/bin

#-----------------------------------------------------------------------------
TRG_NAME       := ip_filter
TRG_SFX        := 

#-----------------------------------------------------------------------------
uniq    = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
fixPath = $1

#------------------------------------------------------------------------------
#    C flags
#------------------------------------------------------------------------------
C_FLAGS :=
C_FLAGS += -I $(INC_DIR) 
C_FLAGS += -std=c99                 
C_FLAGS += -Wall                   
C_FLAGS += -Wpedantic
C_FLAGS += -O2
C_FLAGS += -g3
C_FLAGS += -save-temps=obj
C_FLAGS += -masm=intel

#------------------------------------------------------------------------------
#    C++ flags
#------------------------------------------------------------------------------
CPP_FLAGS :=
CPP_FLAGS += -I $(INC_DIR) 
CPP_FLAGS += -std=c++17                 
CPP_FLAGS += -Wall                   
CPP_FLAGS += -Wpedantic
CPP_FLAGS += -Og
CPP_FLAGS += -g3
CPP_FLAGS += -save-temps=obj

#------------------------------------------------------------------------------
#    linker flags
#------------------------------------------------------------------------------
LD_FLAGS :=
LD_FLAGS += -Wl,-Map=$(TRG_DIR)/$(TRG_NAME).map

#------------------------------------------------------------------------------
CC        := gcc
CXX       := g++
LD        := g++
AR        := ar
OD        := objdump

#------------------------------------------------------------------------------
#    C sources
#------------------------------------------------------------------------------
C_SRC   := 


#------------------------------------------------------------------------------
#    C++ sources
#------------------------------------------------------------------------------
CPP_SRC   := $(SRC_DIR)/ip_filter.cpp

#------------------------------------------------------------------------------
#    libs
#------------------------------------------------------------------------------
LIBS :=
LIBS += -lm

#------------------------------------------------------------------------------

TRG_FILE  := $(TRG_NAME)$(TRG_SFX)

C_FLAGS   := $(strip $(C_FLAGS))
CPP_FLAGS := $(strip $(CPP_FLAGS))
LD_FLAGS  := $(strip $(LD_FLAGS))

OBJ_C    := $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(C_SRC)))
OBJ_CPP  := $(patsubst %.cpp,$(OBJ_DIR)/%.o,$(notdir $(CPP_SRC)))

TRG_DASM := $(TRG_DIR)/$(TRG_NAME).dasm
TRG      := $(TRG_DIR)/$(TRG_FILE)

C_SRC_DIRS   := $(dir $(C_SRC))
CPP_SRC_DIRS := $(dir $(CPP_SRC))
vpath %.c   $(call uniq, $(C_SRC_DIRS))
vpath %.cpp $(call uniq, $(CPP_SRC_DIRS))

#------------------------------------------------------------------------------
.PHONY: all lib clean print-%

all:    $(TRG)

clean:
	rm -rf $(OBJ_DIR) $(TRG_DIR)

print-%:
	@echo $* = $($*)

#------------------------------------------------------------------------------
$(TRG): $(OBJ_C) $(OBJ_CPP) | $(TRG_DIR)
	$(LD) $(LD_FLAGS) -o $@ $(OBJ_C) $(OBJ_CPP) $(LIBS)
	$(OD) -d $(TRG) > $(TRG_DIR)/$(TRG_NAME).dasm

$(OBJ_C): $(OBJ_DIR)/%.o : %.c | $(OBJ_DIR)
	$(CC) $(PARAMS) $(C_FLAGS) -c $< -o $@

$(OBJ_CPP): $(OBJ_DIR)/%.o : %.cpp | $(OBJ_DIR)
	$(CXX) $(PARAMS) $(CPP_FLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir $(call fixPath, $(abspath $(OBJ_DIR)))		

$(TRG_DIR):
	mkdir $(call fixPath, $(abspath $(TRG_DIR)))		





