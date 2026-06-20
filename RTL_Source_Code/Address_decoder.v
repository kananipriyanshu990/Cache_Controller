//////////////////////////////////////////////////////////////////////////////////
// Module Name: Address_decoder
// Project Name: Cache_Controller
// Module Creation Date: 15.06.2026 
//////////////////////////////////////////////////////////////////////////////////

// 1 byte = 8 bit | 4 byte = 32 bit | 16 byte = 4 x 32 bit 

module Address_decoder(output [19:0] tag,             //20 bit tag
                       output [6:0] index,            //7 bit index
                       output [4:0] offset,           //3 bit offset for word selection + 2 bit offset for byte selection
                       input [31:0] CPU_addr);        //32 bit CPU address
   
   assign offset = CPU_addr[4:0];
   assign index = CPU_addr[11:5];
   assign tag = CPU_addr[31:12]; 
endmodule
