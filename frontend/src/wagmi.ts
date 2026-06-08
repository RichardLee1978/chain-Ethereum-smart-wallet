import { cookieStorage, createConfig, createStorage, http } from 'wagmi'
import { mainnet, sepolia, anvil, } from 'wagmi/chains'

export function getConfig() {
  return createConfig({
    chains: [mainnet, sepolia,anvil],
    storage: createStorage({
      storage: cookieStorage,
    }),
    ssr: true,
    transports: {
      [mainnet.id]: http(),
      [sepolia.id]: http(),
      [anvil.id]:http()
    },
  })
}

declare module 'wagmi' {
  interface Register {
    config: ReturnType<typeof getConfig>
  }
}
