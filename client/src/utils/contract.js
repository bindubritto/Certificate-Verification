import { ethers } from 'ethers';
import InstituteABI from '../InstituteABI.json';

export default async function getInstituteContract() {
	
	const contractABI = InstituteABI;
	
	const contractAddress = `${process.env.VUE_APP_INSTITUTION_CONTRACT_ADDRESS}`; // need to get it by parameter
	console.log('add', contractAddress);
	const provider = new ethers.providers.Web3Provider(window.ethereum);
	const signer = provider.getSigner();

	const contractInstance = new ethers.Contract(
		contractAddress,
		contractABI,
		signer
	);
	
	return contractInstance;
}