import React, { useState } from 'react';
import QRCode from 'react-qr-code';
import axios, { AxiosError } from 'axios';
import './App.css';
import { Button } from './components/ui/button';
import { Input } from './components/ui/input';

// Interface for ArifPay API response
interface ArifPayResponse {
  error: boolean;
  msg: string;
  data: {
    paymentUrl?: string;
    sessionId: string;
    transaction: {
      transactionId: string;
      transactionStatus: string;
    };
  };
}

// Generate 10-character alphanumeric nonce
const generateNonce = (): string => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return Array.from({ length: 10 }, () => 
    chars.charAt(Math.floor(Math.random() * chars.length))
  ).join('');
};

const App: React.FC = () => {
  const [phone, setPhone] = useState<string>('');
  const [amount, setAmount] = useState<string>('');
  const [qrUrl, setQrUrl] = useState<string>('https://checkout.arifpay.org/checkout/A63D4067DE3D');
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || 'https://gateway.arifpay.org/api/sandbox/checkout//transfer/direct';
  const apiToken = import.meta.env.VITE_ARIFY_PAYKEY;

  const handleGenerateQR = async () => {
    if (!apiToken) {
      setError('API token missing. Check environment variables.');
      return;
    }

    setError(null);
    setIsLoading(true);

    const nonce = generateNonce();
    const expireDate = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();

    try {
      const response = await axios.post<ArifPayResponse>(
        `${apiBaseUrl}`,
        {
          phone_number: phone.replace('+', ''), // Normalize phone (remove +)
          expireDate,
          nonce,
          amount: parseFloat(amount) || 0,
        },
        {
          headers: {
            Authorization: `Bearer ${apiToken}`,
            'Content-Type': 'application/json',
          },
        }
      );

      const { data } = response;
      if (data.error) {
        setError(`API Error: ${data.msg}`);
        return;
      }

      if (data.data.paymentUrl) {
        setQrUrl(data.data.paymentUrl);
      } else {
        setError('No payment URL returned from ArifPay');
      }
    } catch (err) {
      const error = err as AxiosError<{ message?: string }>;
      const errorMsg = error.response?.data?.message || error.message;
      setError(`Failed to generate QR: ${errorMsg}`);
      console.error('API Error:', error.response?.data || error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="container mx-auto p-4">
      <h2 className="text-2xl font-bold mt-5 text-center">Generate QR Code</h2>
      <div className="border border-gray-600 w-full max-w-md p-6 rounded-2xl mx-auto">
        <div className="flex flex-col gap-2">
          <label htmlFor="phone" className="text-sm font-medium">Phone Number</label>
          <Input
            id="phone"
            type="text"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            placeholder="e.g., +251985235803"
            className="border-gray-300"
          />
        </div>
        <div className="flex flex-col gap-2 mt-4">
          <label htmlFor="amount" className="text-sm font-medium">Amount (ETB)</label>
          <Input
            id="amount"
            type="number"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            placeholder="Enter amount"
            className="border-gray-300"
          />
        </div>
        <Button
          className="bg-blue-500 text-white mt-4 w-full"
          onClick={handleGenerateQR}
          disabled={!phone || !amount || isLoading}
        >
          {isLoading ? 'Generating...' : 'Generate QR'}
        </Button>
        {error && (
          <div className="text-red-500 text-sm mt-2 text-center">{error}</div>
        )}
      </div>
      <div className="mt-6 flex justify-center" style={{ backgroundColor: 'white', padding: '16px' }}>
        {qrUrl ? (
          <QRCode value={qrUrl} size={200} bgColor="#FFFFFF" fgColor="#000000" />
        ) : (
          <span className="text-gray-500">No QR code generated</span>
        )}
      </div>
    </div>
  );
};

export default App;