/* Toggle capslock on windows
 *
 * http://msdn.microsoft.com/en-us/library/windows/desktop/ms646304(v=vs.85).aspx
 * http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
 */

#include <windows.h>

int _tmain(int argc, _TCHAR* argv[])
{
	keybd_event(VK_CAPITAL, 0x14, KEYEVENTF_EXTENDEDKEY | 0, 0);
	keybd_event(VK_CAPITAL, 0x14, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);
	return 0;
}

