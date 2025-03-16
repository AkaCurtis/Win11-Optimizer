# Windows 11 Optimization Script

## Overview
This batch script applies various optimizations to improve Windows 11 performance, especially on low-spec devices. It enhances system responsiveness, optimizes power settings, and disables unnecessary services.

## Features
- Enables **Ultimate Performance** power plan
- Detects **SSD/HDD** and applies appropriate optimizations
- Optionally disables **Superfetch (SysMain), Windows Search, and Xbox services**
- Clears RAM and refreshes Windows Explorer
- Enables **SSD TRIM** and runs **Disk Cleanup**
- Flushes DNS cache and optimizes network settings
- Checks **disk health status**

## Usage
1. **Download & Extract** the script.
2. **Right-click** `Win11-Optimizer.bat` and select **Run as Administrator**.
3. Follow the on-screen prompts to apply optimizations.

## Notes
- Most optimizations are permanent unless manually changed.
- To revert, adjust services in `services.msc` and reset power plans via `powercfg`.
