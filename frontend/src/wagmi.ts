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
   // multiInjectedProviderDiscovery: false//必须关闭多钱包发现，否则在移动端 MetaMask 会重复触发连接
  })
}

declare module 'wagmi' {
  interface Register {
    config: ReturnType<typeof getConfig>
  }
}
