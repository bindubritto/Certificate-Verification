// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Institution is Ownable {
    
    struct Certificate {
        string Name;
        uint256 Roll;
        uint256 RegistrationNo;
        uint256 SessionId;
        uint256 ProgrammeId;
        string IpfsUrl;
    }

    struct Application {
        uint256 Id;
        string Name;
        uint256 Roll;
        uint256 RegistrationNo;
        uint256 SessionId;
        uint256 ProgrammeId;
        string IpfsUrl;
        bool Verified;
    }

    struct Programme {
        uint256 Id;
        string Name;
        uint256 Duration;
    }

    struct Session {
        uint256 Id;
        uint256 startTimestamp;
        uint256 endTimestamp;
    }

    address public InstitutionVerifier;
    address payable public InstitutionWallet;
    uint256 public totalProgramme = 0;
    uint256 public totalSession = 0; 
    uint256 public totalCertificate = 0;
    uint256 public totalApplication = 0;   




}
