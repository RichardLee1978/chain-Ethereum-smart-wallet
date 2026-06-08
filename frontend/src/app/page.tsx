'use client'

import { useConnect, useConnection, useConnectors, useDisconnect } from 'wagmi'
import { ConnectButton,WalletButton  } from '@rainbow-me/rainbowkit';

import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
function App() {
  const connection = useConnection()
  const { connect, status, error } = useConnect()
  const connectors = useConnectors()
  const { disconnect } = useDisconnect()

  return (
    <div className='w-1/2 mx-auto'>
    <Card className="w-full max-w-full">
      {connection.status === 'connected'?
      <CardHeader className='flex flex-col justify-center items-center'>
        <CardTitle>Connection</CardTitle>
        <CardDescription >
          That's your Wallet account Infi:
        </CardDescription>
        <CardAction className='flex-col flex justify-center items-center w-full'>
          <ul className='flex-col flex justify-center items-center w-full gap-2'>
            <li className='w-full'>Wallet status: {connection.status}</li>
            <li className='w-full'>Wallet addresses: {JSON.stringify(connection.addresses)}</li>
            <li className='w-full'>chainId: {connection.chainId}</li>
          </ul>
        </CardAction>
      </CardHeader>
      :
      <CardHeader className='flex flex-col justify-center items-center'>
          <CardTitle>no Connection</CardTitle>
          <CardDescription >
            please press the button to Connectting wallet!
          </CardDescription>
          <CardAction className='flex-col flex justify-center items-center w-full'>
            
          </CardAction>
      </CardHeader>
      }
      
      <CardContent className='flex-col flex justify-center items-center w-full'>
       
      </CardContent>
      <CardFooter className="flex-col gap-2">
          {connection.status === 'connected' ? 
          <>
          <button type="button" onClick={() => disconnect()} >
            Disconnect
          </button>
          
          </>
          :
          <ConnectButton accountStatus="avatar" />
        }
      </CardFooter>
    </Card>
      

      <div className='flex flex-col justify-center items-center'>
        <h2 className='flex flex-row justify-center items-center'>Connect</h2>
        <div  className='flex flex-row justify-center items-center gap-8'>
       
            {connectors.map((connector,_index) => (
           // <WalletButton wallet='rainbow' key={`WalletButton${_index}`} />

           
           <button key={`${connector.uid}`} onClick={() => connect({ connector })}>{connector.name}</button>
             
          ))}
         
        </div>
        <div>{status}</div>
        <div>{error?.message}</div>
      </div>
    </div>
  )
}

export default App
