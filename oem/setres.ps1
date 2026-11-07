Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Display {
    [DllImport("user32.dll")]
    public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string dmDeviceName;
        public short dmSpecVersion;
        public short dmDriverVersion;
        public short dmSize;
        public short dmDriverExtra;
        public int dmFields;
        public int dmPositionX;
        public int dmPositionY;
        public int dmDisplayOrientation;
        public int dmDisplayFixedOutput;
        public short dmColor;
        public short dmDuplex;
        public short dmYResolution;
        public short dmTTOption;
        public short dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string dmFormName;
        public short dmLogPixels;
        public int dmBitsPerPel;
        public int dmPelsWidth;
        public int dmPelsHeight;
        public int dmDisplayFlags;
        public int dmDisplayFrequency;
        public int dmICMMethod;
        public int dmICMIntent;
        public int dmMediaType;
        public int dmDitherType;
        public int dmReserved1;
        public int dmReserved2;
        public int dmPanningWidth;
        public int dmPanningHeight;
    }

    public static void ChangeResolution(int width, int height) {
        DEVMODE dm = new DEVMODE();
        dm.dmDeviceName = new string(new char[32]);
        dm.dmFormName = new string(new char[32]);
        dm.dmSize = (short)Marshal.SizeOf(dm);
        dm.dmPelsWidth = width;
        dm.dmPelsHeight = height;
        dm.dmFields = 0x00080000 | 0x00100000;
        ChangeDisplaySettings(ref dm, 0);
    }
}
"@

[Display]::ChangeResolution(1920, 1080)
