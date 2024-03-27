# PowerShell Utilities for Microsoft Active Directory

This is a collection of various PowerShell scripts to assist with security and quality-of-life tasks in a Windows Active Directory environment.  


## Getting Started

These scripts (.ps1 files) are designed for use in any Windows 10/11 operating system environment. You can either download the entire directory or simply copy and paste the scripts you need from the repository. Each file contains its own specific instructions for use.

Pro Tip: These were very useful when used with a remote asset management tool like PDQ Deploy.  


## Security Directory
These scripts are intended for situations where security vulnerabilities need to be quickly addressed at the client level, despite most issues ideally being managed through higher-level configurations (e.g., IntraID, Intune, GPOs). The inclusion of "_Revert" scripts allows for rapid rollback of changes to mitigate any impact on production applications.

- **File Names**: Designed to be self-explanatory, indicating the specific setting or application they address.
- **Revert Capability**: Some scripts include a "_Revert" version, enabling quick rollback of changes if necessary.


## Quality-of-Life Directory

### ExpiredUsers.ps1
Constantly getting bothered about expired AD passwords? This identifies users with passwords expiring within the next week and sends a report via email.

### ResetWindowsUpdates.ps1
Windows updates stuck in a failure loop? Use this to clear out the client-side state and try again.


## License
MIT. See the LICENSE file for more information.
