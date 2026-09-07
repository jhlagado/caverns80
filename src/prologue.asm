; CP/M transient entry: owns its stack; restart discards old command frames.
        ORG $0100
CODSTA:
        JP START
