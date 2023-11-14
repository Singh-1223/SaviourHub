// SPDX-License-Identifier: Unlicensed

// Specify the Solidity version range compatible with the contract
pragma solidity >0.7.0 <=0.9.0;

// Contract for creating and managing crowdfunding campaigns
contract CampaignFactory {
    // Array to store addresses of deployed campaigns
    address[] public deployedCampaigns;

    // Event triggered when a new campaign is created
    event campaignCreated(
        string title,
        uint256 requiredAmount,
        address indexed owner,
        address campaignAddress,
        string imgURI,
        uint256 indexed timestamp,
        string indexed category
    );

    // Function to create a new campaign
    function createCampaign(
        string memory campaignTitle,
        uint256 requiredCampaignAmount,
        string memory imgURI,
        string memory category,
        string memory storyURI
    ) public {
        // Deploy a new campaign contract
        Campaign newCampaign = new Campaign(
            campaignTitle,
            requiredCampaignAmount,
            imgURI,
            storyURI
        );

        // Add the new campaign's address to the list
        deployedCampaigns.push(address(newCampaign));

        // Trigger the campaignCreated event
        emit campaignCreated(
            campaignTitle,
            requiredCampaignAmount,
            msg.sender,
            address(newCampaign),
            imgURI,
            block.timestamp,
            category
        );
    }
}

// Contract representing an individual crowdfunding campaign
contract Campaign {
    // Campaign details
    string public title;
    uint256 public requiredAmount;
    string public image;
    string public story;
    address payable public owner;
    uint256 public receivedAmount;

    // Event triggered when a donation is made
    event donated(
        address indexed donar,
        uint256 indexed amount,
        uint256 indexed timestamp
    );

    // Constructor to initialize campaign details
    constructor(
        string memory campaignTitle,
        uint256 requiredCampaignAmount,
        string memory imgURI,
        string memory storyURI
    ) {
        title = campaignTitle;
        requiredAmount = requiredCampaignAmount;
        image = imgURI;
        story = storyURI;
        owner = payable(msg.sender);
    }

    // Function to make a donation to the campaign
    function donate() public payable {
        // Ensure the required amount is not fulfilled
        require(requiredAmount > receivedAmount, "required amount fulfilled");

        // Transfer the donation to the campaign owner
        owner.transfer(msg.value);

        // Update the received amount
        receivedAmount += msg.value;

        // Trigger the donated event
        emit donated(msg.sender, msg.value, block.timestamp);
    }
}
