'use client'

import { useConnect, useConnection, useConnectors, useDisconnect } from 'wagmi'

function App() {
  const connection = useConnection()
  const { connect, status, error } = useConnect()
  const connectors = useConnectors()
  const { disconnect } = useDisconnect()

  return (
    <>
      <div className='flex flex-col justify-center items-center'>
        <h2 className='flex flex-row justify-center items-center'>Connection</h2>

        <div>
          status: {connection.status}
          <br />
          addresses: {JSON.stringify(connection.addresses)}
          <br />
          chainId: {connection.chainId}
        </div>

        {connection.status === 'connected' && (
          <button type="button" onClick={() => disconnect()} 
            
          >
            Disconnect
          </button>
        )}
      </div>

      <div className='flex flex-col justify-center items-center'>
        <h2 className='flex flex-row justify-center items-center'>Connect</h2>
        <div  className='flex flex-row justify-center items-center gap-8'>
        {connectors.map((connector) => (
          <button
            key={connector.uid}
            className='text-white bg-gradient-to-br from-purple-600 to-blue-500 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800 font-medium rounded-base text-sm px-4 py-2.5 text-center leading-5'
            onClick={() => connect({ connector })}
            type="button"
          >
            {connector.name}
          </button>
        ))}
        </div>
        <div>{status}</div>
        <div>{error?.message}</div>
      </div>
    </>
  )
}

export default App
