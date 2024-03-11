# FSSD: FPGA-based Emulator for SSDs

![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

## Overview
FSSD is an FPGA-based emulator for solid-state drives (SSDs), designed to provide a high-performance and flexible platform for SSD emulation. This project is implemented using Vivado 2019.2 and is aimed at facilitating research and development in the field of SSDs. This work is published on FPL 2023.

## Installation

### Prerequisites
Prior to initiating the project setup, the following prerequisites must be fulfilled:

#### Obtaining License

To obtain a license for the Xilinx NVMe Target Controller:

1. Navigate to the [Xilinx NVMe Target Controller IP Page](https://www.xilinx.com/products/intellectual-property/ef-di-nvmetc.html).
2. Click on 'Evaluate IP', and complete the required prompts.
3. You will receive an email from Xilinx with an attachment named 'Xilinx.lic'. Download this file.
4. In Vivado, navigate to `Help -> Manage License... -> Load License`.
5. Choose the downloaded 'Xilinx.lic' file and click 'OK'.
6. Verify the license status in Vivado by selecting 'View License Status' and clicking 'Refresh'.

#### Obtaining the Required Files

1. Navigate to the [Xilinx NVMe Target Controller IP Page](https://www.xilinx.com/products/intellectual-property/ef-di-nvmetc.html).
2. Click on 'Access Secure Site', and complete the required prompts.
3. Locate the 'Document' section for Vivado 2019.2, download the `NVMeTC Reference Design User Guide v1.0`.
4. Locate the 'NVMe TC Hardware Reference Design' section for Vivado 2019.2 and proceed with the selection.
5. Complete the required fields to initiate the download of `NVMeTC_Hardware_Reference_Design_package.tar.gz`.
6. Decompress the downloaded file, ensuring the presence of the `NVMeTC/hw/250s+/local_pcores` directory.

### Project Setup
The project source code are available here at: [FSSD Source Code](https://drive.google.com/file/d/1tltqKoNzMn-BJt2UZwoO9gbLbXFCqd-z/view?usp=share_link)
Follow these steps to configure the Vivado project:

1. **Open the Vivado Project**:
   - Start Vivado 2019.2.
   - Select `Create Project`.
   - Create a Vivado RTL Project, with Boards selected as [Virtex UltraScale+ VCU118 Evaluation Platform](https://www.xilinx.com/products/boards-and-kits/vcu118.html#documentation).

2. **Incorporate the Source Code Folders**:
   - Within Vivado, access `Tools -> Settings...`.
   - In Project Settings, opt for `IP -> Repository`.
   - Append the previously extracted `local_pcores` folder in [Obtaining the Required Files](#obtaining-the-required-files).
   - Append the `fssd.ipdefs` folder found in the published release.

3. **Acquire and Integrate the Xilinx NVMe Target Controller License**:
   - Adhere to the instructions in the [Obtaining License](#obtaining-license) segment for license procurement.
   - Incorporate the acquired license into your project as outlined.

4. **Complete the Project Setup**:
   - Within Vivado, access `Tools -> Run Tcl Script...`.
   - Select the `design_1.tcl` file found in the published release.
   - Wait for the script to finish loading.
   - Users are now equipped to proceed with synthesis, implementation, or bitstream generation as required.

### FPGA Deployment
Follow instructions in the `NVMeTC Reference Design User Guide v1.0` document. 

