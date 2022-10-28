// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./IInstitution.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error InvalidProgram();
error InvalidSession();
error InvalidVerifier();
error InvalidApplicationId();
error ApplicationLimitExceeded();
error ValueCanNotBeZero();
error InvalidAddress();
error InvalidIssuer();
error AlreadyVerified();

contract Institution is IInstitution, Ownable {
    modifier validAddress(address _address) {
        if (_address == address(0) || _address == address(this)) {
            revert InvalidAddress();
        }
        _;
    }

    modifier notZero(uint256 amount) {
        if (amount == 0) {
            revert ValueCanNotBeZero();
        }
        _;
    }

    modifier validVarifier(address _address) {
        if (!institutionVerifiers[_address]) {
            revert InvalidVerifier();
        }
        _;
    }

    modifier onlyIssuer(address _address) {
        if (_address != controllerContractAddress) {
            revert InvalidVerifier();
        }
        _;
    }

    struct Certificate {
        string name;
        uint256 roll;
        uint256 registrationNo;
        uint256 sessionId;
        uint256 programId;
        string ipfsUrl;
        address owner;
    }

    struct Application {
        uint256 id;
        string name;
        uint256 roll;
        uint256 registrationNo;
        uint256 sessionId;
        uint256 programId;
        string ipfsUrl;
        address applicant;
        bool verified;
    }

    struct Program {
        string name;
        uint256 duration;
    }

    struct Session {
        uint256 startTimestamp;
        uint256 endTimestamp;
    }

    mapping(address => bool) public institutionVerifiers;

    address payable public institutionWallet;
    address public controllerContractAddress;

    uint256 public totalProgram = 0;
    uint256 public totalSession = 0;
    uint256 public totalCertificate = 0;
    uint256 public totalApplication = 0;

    uint256 public applicationperWallet = 10;

    mapping(uint256 => Session) public sessions;

    mapping(uint256 => Application) public applications;
    mapping(uint256 => Certificate) public certificates;

    mapping(uint256 => Program) public programs;

    mapping(address => uint256) public applicationPerWalletMapping;

    constructor(
        address _issuerContractAddress,
        address payable _institutionWallet
    ) {
        institutionWallet = payable(_institutionWallet);
        controllerContractAddress = _issuerContractAddress;
    }

    function applyForCertificate(
        string memory _name,
        uint256 _roll,
        uint256 _registrationNo,
        uint256 _sessionId,
        uint256 _programId,
        string memory _ipfsUrl
    ) external {
        if (_programId < 1 || _programId > totalProgram) {
            revert InvalidProgram();
        }

        if (_sessionId < 1 || _sessionId > totalSession) {
            revert InvalidSession();
        }

        if (applicationPerWalletMapping[msg.sender] == applicationperWallet) {
            revert ApplicationLimitExceeded();
        }

        applicationPerWalletMapping[msg.sender]++;
        totalApplication++;

        applications[totalApplication] = Application(
            totalApplication,
            _name,
            _roll,
            _registrationNo,
            _sessionId,
            _programId,
            _ipfsUrl,
            msg.sender,
            false
        );
    }

    function verifyCertificate(uint256 _applicationId)
        external
        validVarifier(msg.sender)
        notZero(_applicationId)
    {
        if (_applicationId < 1 || _applicationId > totalApplication) {
            revert InvalidApplicationId();
        }

        Application memory application = applications[_applicationId];

        if (application.verified == true) {
            revert AlreadyVerified();
        }

        totalCertificate++;
        applicationPerWalletMapping[application.applicant]--;
        applications[_applicationId].verified = true;
        certificates[totalCertificate] = Certificate(
            application.name,
            application.roll,
            application.registrationNo,
            application.sessionId,
            application.programId,
            application.ipfsUrl,
            application.applicant
        );
    }

    function addSessions(uint256 _startTimestamp, uint256 _endTimestamp)
        external
        onlyIssuer(msg.sender)
    {
        if (_startTimestamp >= _endTimestamp) {
            revert InvalidSession();
        }
        totalSession++;

        sessions[totalSession] = Session(_startTimestamp, _endTimestamp);
    }

    function addProgram(string memory _name, uint256 _duration)
        external
        onlyIssuer(msg.sender)
        notZero(_duration)
    {
        totalProgram++;

        programs[totalProgram] = Program(_name, _duration);
    }

    function addVerifier(address _verifier)
        external
        validAddress(_verifier)
        onlyIssuer(msg.sender)
    {
        institutionVerifiers[_verifier] = true;
    }

    function removeVerifier(address _verifier)
        external
        validAddress(_verifier)
        onlyIssuer(msg.sender)
    {
        institutionVerifiers[_verifier] = false;
    }

    function resetIssuerContractAddress(address _address)
        external
        onlyOwner
        validAddress(_address)
    {
        controllerContractAddress = _address;
    }

    function resetInstitutionWallet(address _address)
        external
        onlyOwner
        validAddress(_address)
    {
        institutionWallet = payable(_address);
    }

    function unverifiedApplications()
        public
        view
        returns (Application[] memory data)
    {
        Application[] memory tmp = new Application[](totalApplication);

        uint256 count = 0;
        for (uint256 i = 1; i <= totalApplication; i++) {
            Application memory application = applications[i];
            if (application.verified == false) {
                tmp[count] = application;
                count += 1;
            }
        }
        Application[] memory data = new Application[](count);
        for (uint256 i = 0; i < count; i++) {
            data[i] = tmp[i];
        }
        return data;
    }

    function ownerOfCertificates(address _address)
        public
        view
        returns (Certificate[] memory data)
    {
        Certificate[] memory tmp = new Certificate[](totalCertificate);

        uint256 count = 0;
        for (uint256 i = 1; i <= totalCertificate; i++) {
            Certificate memory certificate = certificates[i];
            if (certificate.owner == _address) {
                tmp[count] = certificate;
                count += 1;
            }
        }
        Certificate[] memory data = new Certificate[](count);
        for (uint256 i = 0; i < count; i++) {
            data[i] = tmp[i];
        }
        return data;
    }
}
