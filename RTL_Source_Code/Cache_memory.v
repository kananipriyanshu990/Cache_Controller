//////////////////////////////////////////////////////////////////////////////////
// Module Name: Cache_memory
// Project Name: Cache_Controller
// Module Creation Date: 16.06.2026 
// Modification: 17.06.26 : Added documentation comments
//////////////////////////////////////////////////////////////////////////////////

// Information:
// one line has 32 bytes = 256 bits
// there are 128 such line
// total 128 x 256 = 32768 bits
// 1 byte = 8 bits
// 32768/8 bits = 4096 bytes for data storage
// 20 bits tag x 128 lines = 2560 bits/8 bits = 320 bytes
// 1 bit 'valid' x 128 lines = 128 bits/8 bits = 16 bytes
// 1 bit 'dirty' x 128 lines = 128 bits/8 bits = 16 bytes
// total bytes of cache_memory = 4096 + 320 + 16 + 16 = 4448 bytes

// NOTE: Byte offset is not used in calculations in this project. It is kept 00.

module Cache_memory(output wire [31:0] read_data,         //data available at cache output
                    output wire [19:0] current_tag,       //tag of selected word-line
                    output wire current_valid,            //valid bit of selected word-line
                    output wire current_dirty,            //dirty bit of selected word-line
                    input [6:0] read_index,               //index of word-line to be read
                    input [2:0] read_offset,              //offset of word-line to be read
                    input write_en,                       //write enable signal, reading allowed when write_en = 0
                    input [6:0] write_index,              //index of word-lin to be written
                    input [2:0] write_offset,             //offset of word-line to be written
                    input [31:0] write_data,              //data to be written in selected word-line
                    input metadata_write_en,              //write enable signal to modify tag
                    input [19:0] tag_in,                  //20 bit tag to be stored at selected index of tag_array
                    input valid_in,                       //'valid' bit to be set at the selected index of valid_bit_array 
                    input dirty_in,                       //dirty bit to be set at selected index in dirty_bit_array
                    input clk,
                    input reset);
  
  integer Index = 0;                                      //index for iterating throughout the memory
  integer W_offset = 0;                                   //word offset for iterating in a word-line
  
  reg [31:0]data_array[127:0][7:0];                       //main data array, 128 lines, each line has 8 words, each word is 32 bit
  reg [19:0]tag_array[127:0];                             //tag array, 128 lines, each line 20 bit wide
  reg valid_bit_array[127:0];                             //'valid' bit array, 128 lines, each line 1 bit wide
  reg dirty_bit_array[127:0];                             //dirty bit array, 128 lines, each line 1 bit wide
  
  assign read_data = data_array[read_index][read_offset];     //combinational output data of present offsetted line being read
  assign current_tag = tag_array[read_index];                 //combinational output tag of present line bing read
  assign current_valid = valid_bit_array[read_index];         //combinational output 'valid' bit of present line bing read
  assign current_dirty = dirty_bit_array[read_index];         //combinational output dirty bit of present line bing read
  
  
  always @(posedge clk or negedge reset)begin                                  //synhronous active-low reset
    if(reset == 1'b0)begin
        for(Index = 0; Index < 128; Index = Index + 1)begin
            for(W_offset = 0; W_offset < 8; W_offset = W_offset + 1)begin
                data_array[Index][W_offset] <= 32'h0000_0000; 
            end
            valid_bit_array[Index] <=  1'b0;                            //reset valid bit of word-line
            dirty_bit_array[Index] <= 1'b0;                             //reset dirty bit of word-line
        end
    end
    else begin
      if(write_en == 1'b1)begin                                      //active-high write_en, updates selected cache location
          data_array[write_index][write_offset] <= write_data;       
      end
      if(metadata_write_en == 1'b1)begin                                  //active-high metadata_write_en, updates tag, valid, dirty fields 
           tag_array[write_index] <= tag_in;
           valid_bit_array[write_index] <= valid_in;
           dirty_bit_array[write_index] <= dirty_in;
      end
    end
  end
  
    
    
endmodule    