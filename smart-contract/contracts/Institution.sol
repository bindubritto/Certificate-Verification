// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

error InvalidProgram();
error InvalidSession();
error InvalidVerifier();
error InvalidApplicationId();
error ApplicationLimitExceeded();
error ValueCanNotBeZero();
error InvalidAddress();
error AlreadyVerified();

contract Institution {
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
        if (!InstitutionVerifiers[_address]) {
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
        address Owner;
    }

    struct Application {
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

    mapping(address => bool) public InstitutionVerifiers;

    address payable public InstitutionWallet;

    uint256 public totalProgram = 0;
    uint256 public totalSession = 0;
    uint256 public totalCertificate = 0;
    uint256 public totalApplication = 0;

    uint256 public ApplicationperWallet = 10;

    mapping(uint256 => Session) public sessions;

    mapping(uint256 => Application) public applications;
    mapping(uint256 => Certificate) public certificates;

    mapping(uint256 => Program) public programs;

    mapping(address => uint256) public applicationPerWalletMapping;

    constructor() {}

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

        if (applicationPerWalletMapping[msg.sender] == 10) {
            revert ApplicationLimitExceeded();
        }

        applicationPerWalletMapping[msg.sender]++;
        totalApplication++;

        applications[totalApplication] = Application(
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
        public
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
        public
    {
        totalSession++;

        sessions[totalSession] = Session(_startTimestamp, _endTimestamp);
    }

    function addProgram(string memory _name, uint256 _duration) public {
        totalProgram++;

        programs[totalProgram] = Program(_name, _duration);
    }

    function addVerifier(address _verifier) public validAddress(_verifier) {
        InstitutionVerifiers[_verifier] = true;
    }
}
