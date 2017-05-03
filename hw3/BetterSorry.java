import java.util.concurrent.atomic.AtomicInteger;

class BetterSorry implements State {
    private byte[] value;
    private byte maxval;
    AtomicInteger newi;
    AtomicInteger newj;

    BetterSorry(byte[] v) { value = v; maxval = 127;}

    BetterSorry(byte[] v, byte m) { value = v;maxval = m;}

    public int size() { return value.length; }

    public byte[] current() { return value;}

    public boolean swap(int i, int j) {
        if (value[i] <= 0 || value[j] >= maxval) {
            return false;
        }
        
       newi = new AtomicInteger(value[i]);
       newj = new AtomicInteger(value[j]);

        value[i] = (byte) newi.decrementAndGet();
        value[j] = (byte) newj.incrementAndGet();
        return true;
    }
}